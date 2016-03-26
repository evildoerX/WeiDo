//
//  WDMessageController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDMessageController: YZDisplayViewController {

    
    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
    var vistorView: WDVistorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if !didlogin
            {
               setupVistorView()
        }
         else{
             setupAllControllers()
             setupTitle()
        }
        navigationItem.title = "消息"
        
        
        
    
 
    }

   func setupVistorView()
   {
    view.addSubview(label1)
    view.addSubview(label2)
    view.addSubview(loginBtn)
    
    
    label1.xmg_AlignVertical(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 30), offset: CGPoint(x: 0, y: -200))
    label2.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: label1, size: CGSize(width: 200, height: 30), offset: CGPoint(x: 0, y: 20))
    loginBtn.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: label2, size: CGSize(width: 92, height: 36), offset: CGPoint(x: 0, y: 20))
    }
    
 
    
    func setupTitle()
    {
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
      
        coverColor = UIColor(white: 0.7, alpha: 1.0)
        coverCornerRadius = 13
        norColor = UIColor.blackColor()
        selColor = UIColor.whiteColor()
    }
    
    
    /**
     添加子控制器
     */
    func setupAllControllers()
    {
        let text = WDMentionMeTableViewController()
        text.title = "@我的评论"
        addChildViewController(text)
        let picture = WDByMeTableViewController()
        picture.title = "我发出的"
        addChildViewController(picture)
        let video = WDToMeTableViewController()
        video.title = "我收到的"
        addChildViewController(video)
    }
    
    
    /**
     点击登录
     */
    func loginClick()
    {
       
        let oauthView = WDOauthViewController()
        let nav = UINavigationController(rootViewController: oauthView)
        presentViewController(nav, animated: true, completion: nil)
    
    }
    
    // MARK: - 懒加载
    
    private lazy var label1: UILabel =
    {
        let label1 = UILabel()
        label1.text = "刷微博,发现乐趣"
        label1.textColor = bgcolor
      label1.textAlignment = NSTextAlignment.Center
        return label1
    }()
    
    private lazy var label2: UILabel =
    {
       let label2 = UILabel()
        label2.text = "总有好友常伴左右"
        label2.textColor = bgcolor
        label2.textAlignment = NSTextAlignment.Center
        
        return label2
    }()
    
    private lazy var loginBtn: UIButton =
    {
       let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "登录按钮背景"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(WDMessageController.loginClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}
