//
//  WDTravel.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/20.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking

class WDTravel: NSObject {

    
    //标题
    var title: String?
    //用户名
    var userName:String?
    //用户头像
    var userHeadImg:String?
    //原帖地址
    var bookUrl:NSURL?
    //总天数
    var routeDays:String?
    //配图
    var headImage:String?
    //路线
    var text:String?
    //开始时间
    var startTime:String?
    //评论数
    var commentCount:String?
    //点赞数
    var likeCount:String?
    //浏览量
    var viewCount:String?
    
    
    init(dictionary:[String:AnyObject]) {
        
        title = dictionary["title"] as? String
   
        userName = dictionary["userName"] as? String
          userHeadImg = dictionary["userHeadImg"] as? String
          let bookUrlStr = dictionary["bookUrl"] as? String
           bookUrl = NSURL(string: bookUrlStr!)
        print(bookUrl!)
         let   routeDaysStr = dictionary["routeDays"] as? Int
        routeDays = String(routeDaysStr!)
        
          headImage = dictionary["headImage"] as? String
          text = dictionary["text"] as? String
          startTime = dictionary["startTime"] as? String
         let commentCountStr = dictionary["commentCount"] as? Int
        commentCount = String(commentCountStr!)
      let  likeCountStr = dictionary["likeCount"] as? Int
        likeCount = String(likeCountStr!)
       
        let  viewCountStr = dictionary["viewCount"] as? Int
        viewCount = String(viewCountStr!)
        
        
    }
    
    
    static func loadTravel(results: [[String: AnyObject]]) -> [WDTravel]
    {
        var travel = [WDTravel]()
        for result in results
        {
           travel.append(WDTravel(dictionary: result))
            
        
        }
        return travel
      
    }
    
    class func loadTravelData(page:Int,finished: (models:[WDTravel]?, error:NSError?)->())
    {
        //key
        let requestpath = "http://apis.baidu.com/qunartravel/travellist/travellist"
        let apikey = "a790ac2a191a4764f40c2f7986b1cd26"
   
        let manager = AFHTTPSessionManager()
         manager.requestSerializer.setValue(apikey, forHTTPHeaderField: "apikey")
        
        let params = ["page":String(page)]
        manager.GET(requestpath, parameters: params, success: { (_, JSON) in
            let model = loadTravel(JSON!["data"]!["books"] as! [[String:AnyObject]])
            
            finished(models: model,error:nil)
            
        }) { (_, error) in
            
            finished(models:nil,error: error)
        }
        
          }

   
}
