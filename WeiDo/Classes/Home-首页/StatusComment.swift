//
//  StatusComment.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/21.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


class StatusComment: NSObject {
    
    var created_at:String?
    var text:String?
    
    
    //user
    var profile_image_url:String?
    var screen_name:String?
    //点赞数
    var source_allowclick:String?
    
    init(dictionary:[String:AnyObject]) {
        
        let created_atStr = dictionary["created_at"] as! String
        // 将字符串转换为时间
        let createdDate = NSDate.dateWithStr(created_atStr)
        // 获取格式化之后的时间字符串
        created_at = createdDate.descDate
        
        
        text = dictionary["text"] as? String
   
        let user = dictionary["user"] as! NSDictionary
        profile_image_url = user.valueForKey("profile_image_url") as? String
      
        screen_name = user.valueForKey("screen_name") as? String
        
    let  source_allowclickStr = dictionary["source_allowclick"] as? Int
        source_allowclick = String(source_allowclickStr!)
 
        

    }
    
    
    static func LoadStatusComment(results: [[String : AnyObject]]) -> [StatusComment] {
        var comment = [StatusComment]()
        
        for result in results {
            comment.append(StatusComment(dictionary: result))
        }
        
        return comment
    }

    class func loadStatusComment(id:Int,page:Int, finished: (models: [StatusComment]? ,error:NSError?) -> ())
    {
           let path = "https://api.weibo.com/2/comments/show.json"
           var params = [String:AnyObject]()
           params["access_token"] = userAccount.loadAccount()!.access_token!
           params["id"] = id
           params["page"] = page
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) in
            let model = LoadStatusComment(JSON!["comments"] as! [[String:AnyObject]])
            finished(models: model, error: nil)
            
            }) { (_, error) in
                finished(models: nil, error: error)
        }
       
    
    }
    
    
}
