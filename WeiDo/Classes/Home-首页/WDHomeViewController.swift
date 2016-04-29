//
//  WDHomeViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

let WDHomeReuseIdentifier = "WDHomeReuseIdentifier"
let WDCommentComposeWillOpen = "WDCommentComposeWillOpen"
let WDPublishWillOpen = "WDPublishWillOpen"
let WDOpenBrowser = "WDOpenBrowser"
let WDPictureWillOpen = "WDPictureWillOpen"

class WDHomeViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllControllers()
        setupTitle()

        // Do any additional setup after loading the view.
    }
    /**
     设置标题样式
     */
    func setupTitle()
    {
     
        
        
        titleScrollViewColor = UIColor.clearColor()
       
        navigationItem.title = "WeiDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), style: .Plain, target: self, action: #selector(WDHomeViewController.rightBtnClick))
        
        
        isShowUnderLine = true
        underLineColor = bgColor
        isShowTitleGradient = true
        isShowTitleCover = false
        
        titleHeight = 38
        endR = 77 / 255.0
        endG = 194 / 255.0
        endB = 167 / 255.0
        
        // 是否显示遮盖
        titleScrollViewColor = UIColor.clearColor()
      
        norColor = UIColor.blackColor()
        selColor = UIColor.whiteColor()
    }
    /**
     添加子控制器
     */
    func setupAllControllers()
    {
        let text = WDHomeTableViewController()
        text.title = "微博"
        addChildViewController(text)
        let travel = WDTravelTableViewController()
        travel.title = "游记"
        addChildViewController(travel)
        let picture = WDSportNewTableViewController()
        picture.title = "体育"
        addChildViewController(picture)
        let video = WDAmusementNewsViewController()
        video.title = "娱乐"
        addChildViewController(video)
        let tech = WDTechnologyNewsViewController()
        tech.title = "科技"
        addChildViewController(tech)
   
      
        
    }
    
    
    /**
     右边按钮监听
     */
    func rightBtnClick()
    {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }


}
