//
//  WDBaseViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDBaseViewController: UITableViewController {

    
    
    let height = UIScreen.mainScreen().bounds.height
    let width = UIScreen.mainScreen().bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                self.tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
                self.tableView.showsVerticalScrollIndicator = false
                self.tableView.showsHorizontalScrollIndicator = false
          }


  

//    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        self.tabBarController?.tabBar.hidden = true
//    }
//    
//    
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        
//        
//        self.tabBarController?.tabBar.hidden = false
//        
//    
//    }

    
    
}
