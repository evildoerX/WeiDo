//
//  WDLatestComments.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDLatestComments: NSObject {

    //用户名
    var username: String?
    //点赞数
    var like_count: Int = 0
    //评论文字
    var content: String?
    //头像
    var profile_image: String?
    //时间
    var ctime: String?
    
    
    init(dictionary: [String: AnyObject]) {
        
        
     let like_countStr = dictionary["like_count"] as? String
        like_count = Int(like_countStr!)!
        content = dictionary["content"] as? String
        ctime = dictionary["ctime"] as? String
        let user = dictionary["user"] as! NSDictionary
        username = user.valueForKey("username") as? String
        profile_image = user.valueForKey("profile_image") as? String
        
        
        
        
        
    }
    static func LoadLatestComments(results: [[String : AnyObject]]) -> [WDLatestComments] {
        var LatestComments = [WDLatestComments]()
        
        for result in results {
            LatestComments.append(WDLatestComments(dictionary: result))
        }
        
        return LatestComments
    }

    
}
