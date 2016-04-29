//
//  WDPictureTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/27.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class WDPictureTableViewController: WDBaseViewController {
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

            
            WDTopic.loadTopicData("10",maxtime: "",page: 0 , finished: { (models, maxtime, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("网络似乎有点问题")
                    return
                }
                else
                {
                self.maxtime = maxtime!
                self.pictures = models!
                self.page = 0
                self.tableView.reloadData()
                self.header.endRefreshing()
                }
            })

            
            
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
            WDTopic.loadTopicData("41", maxtime: self.maxtime, page: currentpage, finished: { (models, maxtime, error) in
                if error != nil
                {
                    print(error)
                    SVProgressHUD.showErrorWithStatus("刷新失败")
                }
                else
                {
                    self.maxtime = maxtime!
                    self.pictures += models!
                    self.page = currentpage
                    self.tableView.reloadData()
                    self.footer.endRefreshing()
                }
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



