//
//  WDPopmenuViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDPopmenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
       
      tableView.backgroundColor = UIColor.clearColor()
        
        /// 设置背景透明
        let view = UIView()
        tableView.tableFooterView = view
     
    }

   
}
extension WDPopmenuViewController: UITableViewDataSource,UITableViewDelegate
{
    
  

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let array = ["我的微博","体育新闻","娱乐新闻","科技新闻"]
        cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.contentView.backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.2)
        
        return cell
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /// 选择对应的控制器
        let indexpath = indexPath.row
        switch indexpath {
            
        case 0:
            dismissViewControllerAnimated(true, completion: nil)
        case 1:
            let nav = UINavigationController(rootViewController: WDSportNewTableViewController())
            
           presentViewController(nav, animated: true, completion: nil)

        case 2:
            let nav = UINavigationController(rootViewController: WDAmusementNewsViewController())
            presentViewController(nav, animated: true, completion: nil)
        
        case 3:
            let nav = UINavigationController(rootViewController: WDTechnologyNewsViewController())
            presentViewController(nav, animated: true, completion: nil)
        default:
            print("见鬼了")
        }
        
    }
    
    
}