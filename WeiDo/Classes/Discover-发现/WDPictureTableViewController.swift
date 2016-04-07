//
//  WDPictureTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/27.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

let WDPictureWillOpen = "WDPictureWillOpen"
let pictureCellReuseIdentifier = "WDPictureCell"
class WDPictureTableViewController: UITableViewController {
    /// 数据源
    var pictures =  [WDTopic]()
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDPictureTableViewController.openPothoBrowser(_:)), name: WDPictureWillOpen, object: nil)
        
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDPictureTableViewController.openShare(_:)), name: WDPictureShare, object: nil)
    }
    
    deinit
    {
     NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func openShare(notify: NSNotification)
    {
        guard let url = notify.userInfo![WDPictureShare] as? String  else
        {
            return
        }
        guard let text = notify.userInfo![WDPictureTextShare] as? String  else
        {
            return
        }

   
        let vc = WDShareViewController(type: 2, text: text, url: url)
       UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
    
    }
    
    /**
     打开图片浏览器
     */
    func openPothoBrowser(notify: NSNotification)
    {
        
        
        guard let urlstr = notify.userInfo![WDPictureWillOpen] as? String  else
        {
            return
        }
        
        
        let urls = [NSURL(string: urlstr)!]
        
        
        //创建控制器 永远只有一张图
        let vc = PhotoBrowserViewController(index: 0, urls: urls)
        // 显示控制器
        presentViewController(vc, animated: true, completion: nil)
        
    }

    
    /**
     设置tableview属性
     */
    func setupTableView()
    {
        tableView.scrollIndicatorInsets = self.tableView.contentInset
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        
        tableView.registerNib(UINib(nibName: "WDPictureCell", bundle: nil), forCellReuseIdentifier: pictureCellReuseIdentifier)
        tableView.rowHeight = 500
    }
  
    /**
     设置上下拉刷新
     */
    func setUpRefrshControl()
    {
    
        /**
        上拉刷新
        */
        tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in
            self.footer.endRefreshing()
            let path = requestPath
            let params = ["a": "list", "c": "data", "type" : "10"]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let picturearray = JSON!["list"] as! [[String:AnyObject]]
                let infoarray = JSON!["info"] as! [String:AnyObject]
                //获取maxtime属性
                self.maxtime = infoarray["maxtime"] as! String
                //字典转模型
                self.pictures = WDTopic.LoadTopic(picturearray)
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
            let params = ["a": "list", "c": "data", "type" : "10", "maxtime": self.maxtime, "page": currentpage]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let picturearray = JSON!["list"] as! [[String:AnyObject]]
                let infoarray = JSON!["info"] as! [String:AnyObject]
                //获取maxtime属性
                self.maxtime = infoarray["maxtime"] as! String
                //字典转模型
                self.pictures += WDTopic.LoadTopic(picturearray)
                //设置页码
                self.page = currentpage
                
                self.tableView.reloadData()
                self.footer.endRefreshing()
                
                
                }, failure: { (_, error) -> Void in
                    print(error)
            })
            
        })
        

    
    
    }


    // MARK  -tableview delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCellWithIdentifier(pictureCellReuseIdentifier, forIndexPath: indexPath) as! WDPictureCell
        let PictureTopic = pictures[indexPath.row]
        cell.pictureTopic = PictureTopic
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let topic = pictures[indexPath.row]
        let vc = WDCommentViewController(textTopic: topic)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
   
    }
    

}



