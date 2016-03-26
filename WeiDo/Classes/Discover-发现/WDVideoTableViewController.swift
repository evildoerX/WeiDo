//
//  WDVideoTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/27.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh
import MediaPlayer

let requestPath = "http://api.budejie.com/api/api_open.php"
let videoCellReuseIdentifier = "WDVideoCell"
class WDVideoTableViewController: UITableViewController {

   
    /// 数据源
    var video =  [WDTopic]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**  footer  */
    var footer:MJRefreshFooter{
        return (self.tableView.tableFooterView as? MJRefreshFooter)!
    }
    /**  当前页  */
    var page = 1
    /**  请求下一页需要的参数  */
    var maxtime = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        setUpRefrshControl()
    }
    
    
    /**
     设置tableview属性
     */
    func setupTableView()
    {
        tableView.scrollIndicatorInsets = self.tableView.contentInset
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        
        tableView.registerNib(UINib(nibName: "WDVideoCell", bundle: nil), forCellReuseIdentifier: videoCellReuseIdentifier)
        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDVideoTableViewController.playVideo(_:)), name: WDVideoWillPlay, object: nil)
        tableView.rowHeight = 500
        
    }
    /**
     移除通知
     */
    deinit
    {
      NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }

    /**
     设置上下拉刷新
     */
    func  setUpRefrshControl()
    {
    
        
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            self.footer.endRefreshing()
            let path = requestPath
            let params = ["a": "list", "c": "data", "type" : "41"]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let videoarray = JSON!["list"] as! [[String:AnyObject]]
               
                let infoarray = JSON!["info"] as! [String:AnyObject]
                //获取maxtime属性
                self.maxtime = infoarray["maxtime"] as! String
                //字典转模型
                self.video = WDTopic.LoadTopic(videoarray)
                //设置页码
                self.page = 0
                
                self.tableView.reloadData()
                self.header.endRefreshing()
                
                }) { (_, error) -> Void in
                    print(error)
            }
            
        })
        header.automaticallyChangeAlpha = true
        header.beginRefreshing()
        /**
        下拉刷新
        */
        
        tableView.tableFooterView = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.header.endRefreshing()
            self.footer.beginRefreshing()
            let currentpage = self.page + 1
            let path = requestPath
            let params = ["a": "list", "c": "data", "type" : "41", "maxtime": self.maxtime, "page": currentpage]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let videoarray = JSON!["list"] as! [[String:AnyObject]]
                let infoarray = JSON!["info"] as! [String:AnyObject]
                //获取maxtime属性
                self.maxtime = infoarray["maxtime"] as! String
                //字典转模型
                self.video += WDTopic.LoadTopic(videoarray)
                //设置页码
                self.page = currentpage
                
                self.tableView.reloadData()
                self.footer.endRefreshing()
                
                
                }, failure: { (_, error) -> Void in
                    print(error)
            })
            
        })
        
        

    
    
    }

    /**
     打开视频
     - parameter notify: 接受通知
     */
    func playVideo(notify: NSNotification)
    {
        
        
        guard let urls = notify.userInfo![WDVideoWillPlay] as? String  else
        {
            return
        }
        let url = NSURL(string: urls)
        let play  = MPMoviePlayerViewController(contentURL: url)
        presentViewController(play, animated: true, completion: nil)
    }
    
    
    
    
    
    
    // MARK - tableview delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.video.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(videoCellReuseIdentifier, forIndexPath: indexPath) as! WDVideoCell
        let videoTopic = video[indexPath.row]
        cell.videoTopic = videoTopic
        
        return cell
    }

  
    
}



