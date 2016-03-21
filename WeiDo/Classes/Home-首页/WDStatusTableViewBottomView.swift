//
//  WDStatusTableViewBottomView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//  有按钮太丑！被我删了

import UIKit
import SDWebImage


class WDStatusTableViewBottomView: UIView {

   
    //设置数据
    var status:Status?
        {
        didSet{
             repostLabel.text = "转发\(String(status!.reposts_count))"
             commentLabel.text = "评论\(String(status!.comments_count))"
             attitudeLabel.text = "赞\(String(status!.attitudes_count))"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
        
    }
    
    
    private func setupUI()
    {
     
        backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 0.04)

        
        addSubview(moreBtn)
        addSubview(repostLabel)
        addSubview(commentLabel)
        addSubview(attitudeLabel)

       moreBtn.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: self, size: CGSize(width: 40, height: 20), offset: CGPoint(x: -40, y: 0))
          repostLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomLeft, referView: self, size: CGSize(width: 60, height: 20), offset: CGPoint(x: 230, y: 0))
          commentLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomLeft, referView: self, size: CGSize(width: 60, height: 20), offset: CGPoint(x: 290, y: 0))
          attitudeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomLeft, referView: self, size: CGSize(width: 60, height: 20), offset: CGPoint(x: 350, y: 0))
        
    }
    
    // MARK: - 懒加载
    // 顶部按钮
    private lazy var moreBtn: UIButton =
    {
        let btn = UIButton()
        btn.setTitle("more", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(11)
        return btn
    }()
    
    private lazy var repostLabel: UILabel =
    {
    let label = UILabel()
        label.text = "转发"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(11)
       return label
    }()
    
    private lazy var commentLabel: UILabel =
    {
        let label = UILabel()
          label.text = "评论"
        
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(11)
        return label
    }()
    private lazy var attitudeLabel: UILabel =
    {
        let label = UILabel()
          label.text = "喜欢"
       label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(11)
        return label
    }()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
 
    
}