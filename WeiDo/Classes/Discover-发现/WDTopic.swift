//
//  WDTopic.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/28.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDTopic: NSObject {
    
    /// id
    var id:Int = 0
    /** 名称 */
    var name:String
    /** 头像 */
    var profile_image:String
    /** 发帖时间 */
    var create_time:String
    /** 文字内容 */
    var text:String
    /** 顶的数量 */
    var ding:Int = 0
    /** 踩的数量 */
    var cai:Int = 0
    /** 转发的数量 */
    var repost:Int = 0
    /** 评论的数量 */
    var comment:Int = 0
    /**新浪微博*/
    var sina_v:String
    /**帖子的类型*/
    var type:Int = 0
    /// 图片
    var cdn_img:String?

    /**  视频时长  */
    var videotime:String?
    /// 视频地址
    var videouri:String?


init(dictionary: [String: AnyObject]) {
    
        let idStr = dictionary["id"] as! String
        id = Int(idStr)!
    
        name = dictionary["name"] as! String
        profile_image = dictionary["profile_image"] as! String
        create_time = dictionary["create_time"] as! String
        text = dictionary["text"] as! String
        
        
        let dingStr = dictionary["ding"] as! String
        ding = Int(dingStr)!
        let caiStr = dictionary["cai"] as! String
        cai = Int(caiStr)!
        
        let repostStr = dictionary["repost"] as! String
        repost = Int(repostStr)!
        
        if let commentStr = dictionary["comment"] as? String{
            comment = Int(commentStr)!
        }else{
            comment = 0
        }
        let typeStr = dictionary["type"] as! String
        type = Int(typeStr)!
        
        if let sina_vStr = dictionary["sina_v"] as? String{
            sina_v = sina_vStr
        }else{
            sina_v = "0"
        }
        cdn_img = dictionary["cdn_img"] as? String

    
        videotime = dictionary["videotime"] as? String
    
        videouri = dictionary["videouri"] as? String
    
    }
    static func LoadTopic(results: [[String : AnyObject]]) -> [WDTopic] {
        var topic = [WDTopic]()
        
        for result in results {
            topic.append(WDTopic(dictionary: result))
        }
        
        return topic
    }
    
}