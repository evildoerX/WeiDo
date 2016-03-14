//
//  WDDiscoverTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/28.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDDiscoverTableViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllControllers()
        setupTitle()
    }
    
    /**
     设置标题样式
     */
    func setupTitle()
    {
     navigationItem.title = "广场"
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        
        
        isShowUnderLine = true
        underLineColor = bgcolor
        isShowTitleGradient = true
        isShowTitleCover = false
        
        titleHeight = 38
        endR = 32 / 255.0
        endG = 142 / 255.0
        endB = 115 / 255.0
        
        // 是否显示遮盖
        titleScrollViewColor = UIColor.whiteColor()
     
        coverColor = UIColor(white: 0.7, alpha: 0.4)
        coverCornerRadius = 13
        norColor = UIColor.blackColor()
        selColor = UIColor.whiteColor()
    }
    /**
     添加子控制器
     */
    func setupAllControllers()
    {
        let text = WDTextTableViewController()
        text.title = "糗事"
        addChildViewController(text)
        let picture = WDPictureTableViewController()
        picture.title = "图片"
        addChildViewController(picture)
        let video = WDVideoTableViewController()
        video.title = "视频"
        addChildViewController(video)
    }
    
   

}
