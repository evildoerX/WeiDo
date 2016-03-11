//
//  WDNews.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

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
    
}
