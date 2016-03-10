//
//  WDFriendViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDFriendViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        setupAllControllers()
        setupTitle()
       
    }
    
 

  func setupTitle()
  {
    navigationItem.title = "好友管理"
    let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
    self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as! [String : AnyObject]
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
    navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    isShowTitleGradient = true
    isShowUnderLine = true
    underLineColor = bgcolor
    
    endR = 255 / 255.0
    endG = 255 / 255.0
    endB = 255 / 255.0
    
    // 是否显示遮盖
    titleScrollViewColor = UIColor(white: 0.9, alpha: 0.8)
   
    coverColor = UIColor.whiteColor()
    coverCornerRadius = 13
    norColor = UIColor.blackColor()
    selColor = bgcolor
    
    }
    /**
     添加子控制器
     */
    func setupAllControllers()
    {
        let fans = WDMyFansTableViewController()
        fans.title = "我的粉丝"
        addChildViewController(fans)
        let follow = WDMyFollowTableViewController()
        follow.title = "我的关注"
        addChildViewController(follow)
        
    }
    
    func back()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
 
}
