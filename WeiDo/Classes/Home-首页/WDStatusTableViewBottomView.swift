//
//  WDStatusTableViewBottomView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

let WDComposeViewWillAppear = "WDComposeViewWillAppear"
let WDRetweetViewWillAppear = "WDRetweetViewWillAppear"
class WDStatusTableViewBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }
    
    
    private func setupUI()
    {
     
        backgroundColor = bgcolor
        
        // 1.添加子控件
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        // 2.布局子控件
        xmg_HorizontalTile([commonBtn, unlikeBtn, retweetBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - 懒加载
    // 转发
    private lazy var retweetBtn: UIButton =
    {
    let btn =  UIButton.createButton("timeline_icon_retweet", title: "分享")
        btn.backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.06)
        btn.addTarget(self, action: "retweet", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    // 赞
    private lazy var unlikeBtn: UIButton =  {
       let btn = UIButton.createButton("timeline_icon_unlike", title: "喜欢")
       btn.backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.06)
         return btn
    }()
    // 评论
    private lazy var commonBtn: UIButton = {
        let btn = UIButton.createButton("timeline_icon_comment", title: "评论")
         btn.backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.06)
           btn.addTarget(self, action: "common", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func common()
    {
      
        NSNotificationCenter.defaultCenter().postNotificationName(WDComposeViewWillAppear, object: self)
        
        
    }
    
    func retweet()
    {
   NSNotificationCenter.defaultCenter().postNotificationName(WDRetweetViewWillAppear, object: self)
    }
    
  
    
    
  
    
}