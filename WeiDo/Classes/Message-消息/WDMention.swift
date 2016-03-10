//
//  WDMention.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDMention: NSObject {

    var created_at: String
    
    var text: String
    
    var screen_name: String
    var profile_image_url: String
    
    init(dictionary: [String: AnyObject]) {
        
        let created_atStr = dictionary["created_at"] as! String
        // 将字符串转换为时间
        let createdDate = NSDate.dateWithStr(created_atStr)
        // 获取格式化之后的时间字符串
        created_at = createdDate.descDate
        
        text = dictionary["text"] as! String
        
        let user = dictionary["user"] as! NSDictionary
        screen_name = user.valueForKey("screen_name") as! String
        profile_image_url = user.valueForKey("profile_image_url") as! String
        
        
    }
    
    static func LoadMention(results: [[String : AnyObject]]) -> [WDMention] {
        var mention = [WDMention]()
        
        for result in results {
            mention.append(WDMention(dictionary: result))
        }
        
        return mention
    }
    
    
    
}
