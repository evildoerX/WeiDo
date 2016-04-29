//
//  WDNearby.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/16.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDNearby: NSObject {
    
 /// 头像
    var profile_image_url: String?
 /// 名字
    var screen_name: String?
 /// 简介
    var Description: String?

    var gender: String?
 /// 粉丝
    var followers_count: String?
 /// 关注
    var friends_count: String?
 /// 距离
    var distacnce: String?
    
    
    init(dictionary: [String: AnyObject]) {
        
        profile_image_url = dictionary["avatar_large"] as? String
        
         screen_name = dictionary["screen_name"] as? String
        
         Description = dictionary["description"] as? String
        
         gender = dictionary["gender"] as? String
        
        followers_count = String(dictionary["followers_count"] as! Int )
        
        friends_count = String(dictionary["friends_count"] as! Int )
        
        distacnce = String(dictionary["distance"] as! Int )
        
    }
    
    static func LoadNearby(results: [[String : AnyObject]]) -> [WDNearby] {
        var nearby = [WDNearby]()
        
        for result in results {
            nearby.append(WDNearby(dictionary: result))
        }
        
        return nearby
    }
    
    
    class func loadNearByData(finished:(models:[WDNearby]?,error:NSError?) -> ())
    {
        var params = [String:AnyObject]()
        params["access_token"] = userAccount.loadAccount()!.access_token!
        params["lat"] = lat!
        params["long"] = long!
        params["range"] = "3000"
        params["count"] = "30"
        params["sort"] = "1"
    
        
          let path = "https://api.weibo.com/2/place/nearby/users.json"
        
    
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) in
            let model = LoadNearby(JSON!["users"] as! [[String:AnyObject]])
            
            finished(models: model, error: nil)
            }) { (_, error) in
                finished(models: nil, error: error)
        }
        
    }

}
