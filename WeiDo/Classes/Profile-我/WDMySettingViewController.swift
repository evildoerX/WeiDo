//
//  WDMySettingViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/12.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD

class WDMySettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigation()
      
    }
    
    func setupTableView()
    {
      tableView.tableFooterView = UIView()
    }
    func setupNavigation()
    {
      
        
        navigationItem.title = "我的"
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]

    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        if section == 0{
        return 1
        }
        else if section == 1
        {
           return 3
        }
        else         {
          return 5
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if indexPath.section == 0
        {
            cell.textLabel?.text = "Bubble-Luliangxiao"
            cell.imageView?.sd_setImageWithURL(NSURL(string: "http://tp3.sinaimg.cn/2715131950/180/5746498542/1"))
           cell.imageView?.layer.cornerRadius = 45
             cell.imageView?.clipsToBounds = true
            
            return cell
        }else if indexPath.section == 1
        {
            let array = ["公开微博","私密微博","我的收藏"]
            
            cell.textLabel?.text = array[indexPath.row]
            return cell
        }
        
        else{
          let array = ["通用设置","分享WeiDo","意见反馈","给WeiDo评分","清除缓存"]
            cell.textLabel?.text = array[indexPath.row]
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 88
        }
        else
        {
          return 44
        }
    }
   

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0
        {
           let vc = WDMineDataViewController()
            let nav = UINavigationController(rootViewController: vc)
            presentViewController(nav, animated: true, completion: nil)
        }
        else if indexPath.section == 1
        {
            let index = indexPath.row
            switch index
            {
            case 0:
                print("000")
            case 1:
                print("111")
            case 2:
                print("222")
            default:
                print("见鬼了")
            }
            
        }
        else
        {
            let index = indexPath.row
            switch index
            {
            case 0:
                
              print("000")
            case 1:
                print("111")
            case 2:
                UIApplication.sharedApplication().openURL(NSURL(string :"sms://18205254911")!)
            case 3:
                print("333")
            case 4:
                StatusDAO.cleanCahcheStatuses()
                SVProgressHUD.showSuccessWithStatus("清除成功！")
            default:
                print("见鬼了")
            }
        
         
        }
    }
    
}
