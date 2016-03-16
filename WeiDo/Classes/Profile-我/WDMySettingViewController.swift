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

    
    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
    var vistorView: WDVistorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的"

        tableView.tableFooterView = UIView()
      
        self.tableView.reloadData()
    }
    
    
   

   
    
 

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        if section == 0{
        return 1
        }
        else if section == 1
        {
           return 3
        }
        else  if section == 2
        {
          return 2
        }
        else
        {
          return 3
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if indexPath.section == 0
        {
            if !didlogin
            {
            cell.textLabel?.text = "未登录"
            cell.imageView?.sd_setImageWithURL(NSURL(string: "greenAvatar_default"))
                
            }else{
                
            cell.textLabel?.text = "Bubble-Luliangxiao"
            cell.imageView?.sd_setImageWithURL(NSURL(string: "http://tp3.sinaimg.cn/2715131950/180/5746498542/1"))
            }
            cell.imageView?.layer.cornerRadius = 45
             cell.imageView?.clipsToBounds = true
            
            return cell
        }else if indexPath.section == 1
        {
            let array = ["公开微博","附近的人","我的收藏"]
            
            cell.textLabel?.text = array[indexPath.row]
            return cell
        }
        
        else if indexPath.section == 2 {
          let array = ["意见反馈","清除缓存"]
            cell.textLabel?.text = array[indexPath.row]
            return cell
        }
        else{
        
            let array = ["通用设置","分享WeiDo","给WeiDo评分"]
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

            self.navigationController?.pushViewController(WDMineDataViewController(), animated: true)
        }
        else if indexPath.section == 1
        {
            let index = indexPath.row
            switch index
            {
            case 0:
            self.navigationController?.pushViewController(WDMineDataViewController(), animated: true)
            case 1:
              
                self.navigationController?.pushViewController(WDNearbyViewController(), animated: true)
            case 2:
               
                SVProgressHUD.showInfoWithStatus("你还没有收藏哦")
            default:
                print("见鬼了")
            }
            
        }
        else if indexPath.section == 2
        {
            let index = indexPath.row
            switch index
            {
            case 0:
                UIApplication.sharedApplication().openURL(NSURL(string :"sms://18205254911")!)
              print("000")
            case 1:
                StatusDAO.cleanCahcheStatuses()
                SVProgressHUD.showSuccessWithStatus("清除成功！")
  
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
                print("通用设置")
            case 1:
               print("分享")
            case 2:
                print("评分")
            default:
                print("见鬼了")
            }
            

        
        }
        
    }
    
}
