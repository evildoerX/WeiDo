//
//  WDNews.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking

class WDNews: NSObject {

    /// 标题
    var title:String?
    var picUrl:String?
    var url:String?
    var ctime:String?
    var newsDescription:String?
    
    init(dictionary: [String: AnyObject]) {
        
        title = dictionary["title"] as? String
        picUrl = dictionary["picUrl"] as? String
        url = dictionary["url"] as? String
        ctime = dictionary["ctime"] as? String
        newsDescription = dictionary["description"] as? String
       
        
    }
    static func LoadNews(results: [[String : AnyObject]]) -> [WDNews] {
        var news = [WDNews]()
        
        for result in results {
            news.append(WDNews(dictionary: result))
        }
        
        return news
    }
    
 
    class func loadNewsData(path:String,finished:(models:[WDNews]?,error:NSError?) -> ())
    {
        let path = "http://api.huceo.com/" + path + "/"
        let manager = AFHTTPSessionManager()
        let newsParams = ["key":"28874a32bce9a4b984c57c3538e68809","num":20]
        manager.GET(path, parameters: newsParams, progress: nil, success: { (_, JSON) -> Void in
            
            let model = LoadNews(JSON!["newslist"] as! [[String:AnyObject]])
            finished(models: model, error: nil)
            
        }) { (_, error) -> Void in
            finished(models: nil, error: error)
        }
    
    }
    
}
