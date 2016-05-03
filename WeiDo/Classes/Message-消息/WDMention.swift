//
//  WDMention.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


class WDMention: NSObject {
    /// 评论id
    var id: Int = 0
    //创建时间
    var created_at: String
    //评论正文
    var text: String
    //评论我的名字
    var screen_name: String
    //评论我的头像
    var profile_image_url: String
    // 原微博id
    var statusId: Int = 0
    // 原微博正文
    var statusText: String?
  
    
    init(dictionary: [String: AnyObject]) {
        
       
        
        id = dictionary["id"] as! Int
        
        let created_atStr = dictionary["created_at"] as! String
        // 将字符串转换为时间
        let createdDate = NSDate.dateWithStr(created_atStr)
        // 获取格式化之后的时间字符串
        created_at = createdDate.descDate
        
        text = dictionary["text"] as! String
        
        let user = dictionary["user"] as! NSDictionary
        screen_name = user.valueForKey("screen_name") as! String
        profile_image_url = user.valueForKey("avatar_large") as! String
        
        
        let status = dictionary["status"] as! NSDictionary
        statusId = (status.valueForKey("id") as? Int)!
        statusText = status.valueForKey("text") as? String

        
       
        
    }
    
    static func LoadMention(results: [[String : AnyObject]]) -> [WDMention] {
        var mention = [WDMention]()
        
        for result in results {
            mention.append(WDMention(dictionary: result))
        }
        
        return mention
    }
    
    
    
    class func loadCacheMessage(type:String,finished:(array:[[String:AnyObject]])->())
    {

        
        let sql = "SELECT * FROM T_message \n" + "WHERE type= '\(type)' \n" + "ORDER BY messageId DESC \n"
    
    SQLiteManager.shareManager().messageDbqueue?.inDatabase({ (db) in
        
        let res = db.executeQuery(sql, withArgumentsInArray: nil)
  
        var message = [[String:AnyObject]]()
    
        while res.next()
        {
            let dictStr = res.stringForColumn("messageText") as String
            let data = dictStr.dataUsingEncoding(NSUTF8StringEncoding)!
            let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String:AnyObject]
            message.append(dict)
        
        
        }
        
        finished(array: message)
        
    })
        
        
        
    
    }
    
    class func cacheMessge(message:[[String:AnyObject]],type:String)

    {
       
        print(type)
        // 1.定义SQL语句
        let sql = "INSERT INTO T_Message" +
            "(messageId, messageText, type)" +
            "VALUES" +
        "(?, ?, ?);"
        

        SQLiteManager.shareManager().messageDbqueue?.inTransaction({ (db,rollback) in
            
            for dict in message
            {
       
             let messageId = dict["id"]!
            let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            let messageText = String(data: data, encoding: NSUTF8StringEncoding)!
            
            
            if !db.executeUpdate(sql,messageId, messageText, type)
            {
       
                rollback.memory = true
                
                }
            
            
            }
            
            
        })
    
    
    
    
    }
    
    
    
    
    
    class func loadMessageData(isNew:Bool,path:String, finished:(models:[WDMention]?,error:NSError?) ->())
        {
            
            
            
            if isNew
            {
                let requestpath = "https://api.weibo.com/2/comments/" + path + ".json"
                let params = ["access_token": userAccount.loadAccount()!.access_token!]
                
                NetworkTools.shareNetworkTools().GET(requestpath, parameters: params, success: { (_, JSON) in
                    
                    let model = LoadMention(JSON!["comments"] as! [[String:AnyObject]])
                    cacheMessge(JSON!["comments"] as! [[String:AnyObject]], type: path)
                    finished(models: model, error: nil)
                }) { (_, error) in
                    finished(models: nil, error: error)
                }
            
                return
            }
            
        

                        loadCacheMessage(path) { (array) in
        
        
                        if !array.isEmpty
                        {
                        let model = LoadMention(array)
                            finished(models: model, error: nil)
                            return
                        }
                    
                            let requestpath = "https://api.weibo.com/2/comments/" + path + ".json"
                            let params = ["access_token": userAccount.loadAccount()!.access_token!]
                            
                            NetworkTools.shareNetworkTools().GET(requestpath, parameters: params, success: { (_, JSON) in
                                
                                let model = LoadMention(JSON!["comments"] as! [[String:AnyObject]])
                                cacheMessge(JSON!["comments"] as! [[String:AnyObject]], type: path)
                                finished(models: model, error: nil)
                            }) { (_, error) in
                                finished(models: nil, error: error)
                            }

                            

            }
                            
            
            
            
    }
    
    
    
    class func cancelData(id:Int,finished:(error:NSError?) -> ())
    {
        let path = "https://api.weibo.com/2/comments/destroy.json"
        var params = [String:AnyObject]()
        params["access_token"] = userAccount.loadAccount()!.access_token!
        params["cid"] = id
        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) in
             finished(error: nil)
            }) { (_, error) in
                     finished(error: error)
        }
        
    
    }
    
    
    
}