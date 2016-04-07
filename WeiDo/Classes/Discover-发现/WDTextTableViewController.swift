//
//  WDTextTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/27.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh

let TextCellReuseIdentifier = "WMWordToipCell"
class WDTextTableViewController: UITableViewController {
    
    //数据源
    var topics =  [WDTopic]()
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
        
        /**
        添加通知
        */
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDTextTableViewController.wordShare(_:)), name: WDWordShare, object: nil)
   
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
   func setupTableView(){
    
    tableView.scrollIndicatorInsets = self.tableView.contentInset
    tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
    tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
    
    tableView.registerNib(UINib(nibName: "WMWordToipCell", bundle: nil), forCellReuseIdentifier: TextCellReuseIdentifier)
    tableView.rowHeight = 200
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //打开分享
    func wordShare(notify:NSNotification)
    {
        
        guard let message = notify.userInfo![WDWordShare] as? String  else
        {
            return
        }
        //1是文本
        let vc = WDShareViewController(type: 1, text: message, url: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: false, completion: nil)
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
        let params = ["a": "list", "c": "data", "type" : "29"]
        let manager = AFHTTPSessionManager()
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            let textarray = JSON!["list"] as! [[String:AnyObject]]
            let infoarray = JSON!["info"] as! [String:AnyObject]

            //获取maxtime属性
            self.maxtime = infoarray["maxtime"] as! String
            //字典转模型
            self.topics = WDTopic.LoadTopic(textarray)
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
            let params = ["a": "list", "c": "data", "type" : "29", "maxtime": self.maxtime, "page": currentpage]
            let manager = AFHTTPSessionManager()
            manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
                let textarray = JSON!["list"] as! [[String:AnyObject]]
                let infoarray = JSON!["info"] as! [String:AnyObject]
              
                //获取maxtime属性
                self.maxtime = infoarray["maxtime"] as! String
               
                
                //字典转模型
                self.topics += WDTopic.LoadTopic(textarray)
                
                //设置页码
                self.page = currentpage
                
                self.tableView.reloadData()
                self.footer.endRefreshing()
                
                
                }, failure: { (_, error) -> Void in
                    print(error)
            })
     
        })
       
        
    }
  

       // MARK - tableview delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return self.topics.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCellWithIdentifier(TextCellReuseIdentifier, forIndexPath: indexPath) as! WMWordToipCell
        let wordTopic = topics[indexPath.row]
        
        cell.wordTopic = wordTopic
        
    

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let topic = topics[indexPath.row]
        let vc = WDCommentViewController(textTopic: topic)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let wordTopic = topics[indexPath.row]
        if let height = rowCache[wordTopic.id]
        {
         return height
        }
        
        let height = UITableViewAutomaticDimension
        rowCache[wordTopic.id] = height
        return height

    }

    
    /// 行高的缓存, 利用字典作为容器. key就是的id, 值就是对应的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
}


