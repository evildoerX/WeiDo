//
//  WDMentionMeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class WDMentionMeTableViewController: WDBaseViewController {


    //数据源
    var mention = [WDMention]()
    /// header
    var header:MJRefreshNormalHeader{
        
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    var sheet: UIActionSheet?
    /**
     评论id
     */
    var id: Int?
    /// 微博id
    var statusid: Int?

    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMessage(false)
        setUpRefrshControl()
        setupTableview()
        
        /**
        添加通知
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDMentionMeTableViewController.cellClick(_:)), name: WDMessageReplyWillOpen, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WDMentionMeTableViewController.cellidClick(_:)), name: WDMessageStatusReplyWillOpen, object: nil)
    }
    deinit
    {
     NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func setupTableview()
    {

        tableView.registerNib(UINib(nibName: "WDMessageCell", bundle: nil), forCellReuseIdentifier: WDMessageCellReuseIdentifier)
        tableView.rowHeight = 150
    }
    
   
        
    func loadMessage(isNew:Bool)
    {
    
    SVProgressHUD.showInfoWithStatus("正在加载数据")
    WDMention.loadMessageData(isNew,path: "mentions") { (models, error) in
        if error != nil
        {
            print(error)
            SVProgressHUD.showErrorWithStatus("好像出错啦,重新登录试试", maskType: .Black)
        }
        else
        {
        
            self.mention = models! + self.mention
          
            self.tableView.reloadData()
            
        }
        
        
    
        
    }
        
        
    }
    /**
     上拉刷新
     */
   func setUpRefrshControl()
   {

    
    /**
    上拉刷新
    */
    tableView.tableHeaderView = MJRefreshNormalHeader.init(refreshingBlock: { () -> Void in

            self.loadMessage(true)
            self.tableView.reloadData()
            self.header.endRefreshing()
        
    })
    header.automaticallyChangeAlpha = true
  

    
    }
    
    

    // MARK: - Table view data source

 

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mention.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WDMessageCellReuseIdentifier, forIndexPath: indexPath) as! WDMessageCell
        let metionData = mention[indexPath.row]
        cell.Mention = metionData
        return cell
    }
    
  
    


}

extension WDMentionMeTableViewController: UIActionSheetDelegate
{
 
    func cellClick(notify: NSNotification)
    {
        guard let id = notify.userInfo![WDMessageReplyWillOpen] as? Int  else
        {
            return
        }
     
        self.id = id

        self.sheet = UIActionSheet(title: "回复", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "删除", otherButtonTitles: "回复")
        self.sheet?.showInView(self.view)
    }
    
    
    /**
     传值用
     */
    func cellidClick(notify: NSNotification)
    {  guard let statusId = notify.userInfo![WDMessageStatusReplyWillOpen] as? Int  else
    {
        return
        
        }
        
         self.statusid = statusId
    
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        //实现删除
        if buttonIndex == 0
        {
            WDMention.cancelData(id!, finished: { (error) in
                if error != nil
                {
                print(error)
                    SVProgressHUD.showErrorWithStatus("删除失败,只能删除自己的评论哦", maskType: .Black)
                }
                else
                {
                 SVProgressHUD.showSuccessWithStatus("删除成功!", maskType: SVProgressHUDMaskType.Black)
                }
            })
            self.tableView.reloadData()
        }

        //实现返回
        if buttonIndex == 1
        {
         self.sheet?.dismissWithClickedButtonIndex(1, animated: true)

        }
        //实现回复
        if buttonIndex == 2
        {
          
        let btnState = 3
        let vc = WDCommentComposeViewController(commentid:id!, state:btnState, statusid:self.statusid!)
        let nav = UINavigationController(rootViewController: vc)
         presentViewController(nav, animated: true, completion: nil)
        }
      
    }
}
