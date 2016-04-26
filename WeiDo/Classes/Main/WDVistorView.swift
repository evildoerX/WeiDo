//
//  WDVistorView.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


protocol WDVistorViewDelegate: NSObjectProtocol
{
    //设置协议方法
     func loginBtnWillClick()
    func registerBtnWillClick()

}

class WDVistorView: UIView {
    
   weak var delegate: WDVistorViewDelegate?
    
    /**
     判断是否是首页界面，然后设置相应的图片
     
     - parameter isHome:    是否是首页
     - parameter imageName: 相应图片
     - parameter text:      相应文字
     */
    func setVistorImageView(isHome:Bool, imageName:String, text:String)
    {
        //不是首页就隐藏图片
        roundImageView.hidden = !isHome
        //修改图片
        homeImageView.image = UIImage(named: imageName)
        
        textLabel.text = text
        if isHome
        {  startAnimation()
        }
        
        
    }
    
    /**
     动画效果
     */
    private func startAnimation()
    {
        //创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        animation.toValue = 2 * M_PI
        animation.duration =  20
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        //加载动画
        roundImageView.layer.addAnimation(animation, forKey: nil);
    
    }
    
    /**
     监听登录按钮点击
     */
    func loginBtnClick()
    {
     
    delegate?.loginBtnWillClick()
    }
    /**
     监听注册按钮点击
     */
    func registerBtnClick()
    {
       
        delegate?.registerBtnWillClick()
    }
    
    
    
    /**
     设置布局
     
     - parameter frame: frame description
     
     - returns: return value description
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
          addSubview(maskBgView)
        addSubview(roundImageView)
        addSubview(homeImageView)
        addSubview(textLabel)
        addSubview(loginBtn)
      
  
        // 2.布局子控件
        // 2.1设置背景
        roundImageView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 2.2设置小房子
        homeImageView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 2.3设置文本
        textLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: roundImageView, size:nil)
        
        // "哪个控件" 的 "什么属性" "等于" "另外一个控件" 的 "什么属性" 乘以 "多少" 加上 "多少"
        let widthCons = NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        // 2.4设置按钮
    
        
        loginBtn.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: textLabel, size: CGSize(width: 92, height: 36), offset: CGPoint(x: 0, y: 20))
        
        // 2.5设置蒙版
        maskBgView.xmg_Fill(self)
    }
    
    //系统要求必须重写
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    
    
    
    
    
// MARK -懒加载控件
    private lazy var roundImageView:UIImageView =
        {
             let rv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
            return rv
    }()
    
    private lazy var homeImageView:UIImageView =
    {
        let hv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return hv
    }()
    
    private lazy var textLabel:UILabel =
    {
        let textLabel = UILabel()
        
    textLabel.numberOfLines = 0
        textLabel.textColor = bgColor
        textLabel.text = "快快登录开启你的微博之旅吧"
     
        return textLabel
    }()
    
    
    private lazy var loginBtn:UIButton =
    {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "登录按钮背景"), forState: UIControlState.Normal)
        loginBtn.addTarget(self, action: #selector(WDVistorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return loginBtn
    }()
    
 
    
    private lazy var maskBgView:UIImageView =
    {
       let maskBgView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return maskBgView
    }()
}
