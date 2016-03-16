//
//  WDMentionMeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh
import SVProgressHUD

class WDMentionMeTableViewController: UITableViewController {

    //数据源
    var mention = [WDMention]()
    /// header
    var header:MJRefreshNormalHeader{
        return (self.tableView.tableHeaderView as? MJRefreshNormalHeader)!
    }
    /**
     评论id
     */
    var id: Int?
    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableview()
        setUpRefrshControl()
  
        /**
        添加通知
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cellClick:", name: WDMessageReplyWillOpen, object: nil)
    }
    deinit
    {
     NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func setupTableview()
    {
        tableView.scrollIndicatorInsets = self.tableView.contentInset
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
        tableView.registerNib(UINib(nibName: "WDMessageCell", bundle: nil), forCellReuseIdentifier: WDMessageCellReuseIdentifier)
        tableView.rowHeight = 60 
        
        
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
//      self.footer.endRefreshing()
        let path = "https://api.weibo.com/2/comments/mentions.json"
        let params = ["access_token": userAccount.loadAccount()!.access_token!]
        let manager = AFHTTPSessionManager()
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
         
            let mentionArray = JSON!["comments"] as! [[String:AnyObject]]
            self.mention = WDMention.LoadMention(mentionArray)
            
            self.tableView.reloadData()
            self.header.endRefreshing()
            
            }) { (_, error) -> Void in
                print(error)
        }
        
    })
    header.automaticallyChangeAlpha = true
    header.beginRefreshing()

    
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
        /// 给cell添加手势
        cell.userInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: "cellClick")
        cell.addGestureRecognizer(tap)
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

        let sheet = UIActionSheet(title: "回复", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "回复")
        sheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
           let btnState = 3
            // (commentid: Int,statusId: Int,  state:Int)
            let vc = WDCommentComposeViewController(commentid:id!, state:btnState)
            let nav = UINavigationController(rootViewController: vc)
            presentViewController(nav, animated: true, completion: nil)
        }
    }
}
