//
//  WDBaseViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDBaseViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                self.tableView.contentInset = UIEdgeInsetsMake(-55 , 0, 49, 0)
                self.tableView.showsVerticalScrollIndicator = false
                self.tableView.showsHorizontalScrollIndicator = false
          }


  
}
