//
//  StatusDAO.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
//数据访问层
class StatusDAO: NSObject {
   
    
    class func loadStatus(since_id: Int, max_id: Int, finished: ([[String: AnyObject]]?, error: NSError?)->()) {
        
        // 1.从本地数据库中获取
        loadCacheStatuses(since_id, max_id: max_id) { (array) -> () in
            
            // 2.如果本地有, 直接返回
            if !array.isEmpty
            {
                SVProgressHUD.showInfoWithStatus("正在加载数据哦...")
                print("从数据库中获取")
                finished(array, error: nil)
                return
            }
            
            
            
            // 3.从网络获取
            let path = "2/statuses/home_timeline.json"
            var params = ["access_token": userAccount.loadAccount()!.access_token!]
            
            // 下拉刷新
            if since_id > 0
            {
                params["since_id"] = "\(since_id)"
            }
            
            // 上拉刷新
            if max_id > 0
            {
                params["max_id"] = "\(max_id - 1)"
            }
            
            
            NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
                let array = JSON!["statuses"] as! [[String : AnyObject]]
              
                // 4.将从网络获取的数据缓存起来
                cacheStatuses(array)
                
                // 5.返回获取到的数据
                finished(array, error: nil)
                
                StatusDAO.cacheStatuses(JSON!["statuses"] as! [[String: AnyObject]])
                
                
                }) { (_, error) -> Void in
                    print(error)
                    SVProgressHUD.showErrorWithStatus("好像出错啦，重新登录试试", maskType: SVProgressHUDMaskType.Black)
                    finished(nil, error: error)
                   
                    
            }
        }
    }
    
    /// 清空过期的数据
    class  func cleanStatuses() {
        
        //        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        let date = NSDate(timeIntervalSinceNow: -60)
        let dateStr = formatter.stringFromDate(date)
        //        print(dateStr)
        
        // 1.定义SQL语句
        let sql = "DELETE FROM T_Status WHERE createDate  <= '\(dateStr)';"
        
        // 2.执行SQL语句
        SQLiteManager.shareManager().dbqueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        })
    }
    
    
    class func cleanCahcheStatuses() {
        
        let sql = "DELETE FROM T_Status"
        
        SQLiteManager.shareManager().dbqueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
            print("删除成功")
        })
        
    }
    


    /// 从数据库中加载缓存数据
    class func loadCacheStatuses(since_id: Int, max_id: Int, finished: ([[String: AnyObject]])->()) {
        
        // 1.定义SQL语句
        var sql = "SELECT * FROM T_Status \n"
        if since_id > 0
        {
            sql += "WHERE statusId > \(since_id) \n"
        }else if max_id > 0
        {
            sql += "WHERE statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n"
        sql += "LIMIT 20; \n"
        
        // 2.执行SQL语句
        SQLiteManager.shareManager().dbqueue?.inDatabase({ (db) -> Void in
            
            // 2.1查询数据
            let res =  db.executeQuery(sql, withArgumentsInArray: nil)
            
            // 2.2遍历取出查询到的数据
            // 返回字典数组的原因:通过网络获取返回的也是字典数组,
            // 让本地和网络返回的数据类型保持一致, 以便于我们后期处理
            var statuses = [[String: AnyObject]]()
            while res.next()
            {
                // 1.取出数据库存储的一条微博字符串
                let dictStr = res.stringForColumn("statusText") as String
                // 2.将微博字符串转换为微博字典
                let data = dictStr.dataUsingEncoding(NSUTF8StringEncoding)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
                statuses.append(dict)
            }
            
            // 3.返回数据
            finished(statuses)
        })
    }
    
    
    /// 缓存微博数据
    class func cacheStatuses(statuses: [[String: AnyObject]])
    {
        
        // 0. 准备数据
        let userId = userAccount.loadAccount()!.uid!
        
        // 1.定义SQL语句
        let sql = "INSERT INTO T_Status" +
            "(statusId, statusText, userId)" +
            "VALUES" +
        "(?, ?, ?);"
        
        // 2.执行SQL语句
        SQLiteManager.shareManager().dbqueue?.inTransaction({ (db, rollback) -> Void in
            
            for dict in statuses
            {
                let statusId = dict["id"]!
                // JSON -> 二进制 -> 字符串
                let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
                let statusText = String(data: data, encoding: NSUTF8StringEncoding)!
               // print(statusText)
                if !db.executeUpdate(sql, statusId, statusText, userId)
                {
                    // 如果插入数据失败, 就回滚
                    rollback.memory = true
                }
                
            }
        })
    }
}
