//
//  Mine.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDMineStatus: NSObject {
 
    ///评论数
    var comments_count:Int = 0
 /// 创建时间
    var created_at:String
 /// 正文
    var text:String
 /// 配图数组
 //   var thumbnail_pic:[NSURL]?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
        {
        didSet{
            // 1.初始化数组
            storedPicURLS = [NSURL]()
            storedLargePicURLS = [NSURL]()
            
            // 2遍历取出所有的图片路径字符串
            for dict in pic_urls!
            {
                if let urlStr = dict["thumbnail_pic"] as? String
                {
                    // 1.将字符串转换为URL保存到数组中
                    storedPicURLS!.append(NSURL(string: urlStr)!)
                    
                    // 2.处理大图
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLS!.append(NSURL(string: largeURLStr)!)
                    
                }
            }
        }
    }
    /// 保存当前微博所有配图的URL
    var storedPicURLS: [NSURL]?
    /// 保存当前微博所有配图"大图"的URL
    var storedLargePicURLS: [NSURL]?
    
    
    
    
    init(dictionary: [String: AnyObject]) {
        
       comments_count = dictionary["comments_count"] as! Int
     
        
      let created_atStr = dictionary["created_at"] as! String
        // 将字符串转换为时间
        let createdDate = NSDate.dateWithStr(created_atStr)
        // 获取格式化之后的时间字符串
        created_at = createdDate.descDate
        
        text = dictionary["text"] as! String
   
    }
    
    static func LoadMine(results: [[String : AnyObject]]) -> [WDMineStatus] {
        var mine = [WDMineStatus]()
        
        for result in results {
            mine.append(WDMineStatus(dictionary: result))
        }
        
        return mine
    }
    
    
    
}
