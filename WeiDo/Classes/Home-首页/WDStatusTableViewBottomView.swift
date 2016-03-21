//
//  WDStatusTableViewBottomView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//  有按钮太丑！被我删了

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
     
        backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.06)

        
        addSubview(retweetBtn)

   retweetBtn.xmg_AlignHorizontal(type: XMG_AlignType.CenterRight, referView: self, size: CGSize(width: 40, height: 20), offset: CGPoint(x: -57, y: 0))
        
    }
    
    // MARK: - 懒加载
    // 顶部按钮
    private lazy var retweetBtn: UIButton =
    {
        let btn = UIButton()
        btn.setTitle("more", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(11)
        return btn
    }()
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
 
    
}