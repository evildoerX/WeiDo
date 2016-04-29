//
//  WDDiscoverTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/28.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


let TextCellReuseIdentifier = "WMWordToipCell"
let pictureCellReuseIdentifier = "WDPictureCell"
let videoCellReuseIdentifier = "WDVideoCell"
let WDCommentCellReuseIdentifier = "WDCommentCell"




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
  
      
        isShowUnderLine = true
        underLineColor = bgColor
        isShowTitleGradient = true
        isShowTitleCover = false
        
        titleHeight = 38
        endR = 77 / 255.0
        endG = 194 / 255.0
        endB = 167 / 255.0
        
        // 是否显示遮盖
        titleScrollViewColor = UIColor.whiteColor()
  
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
