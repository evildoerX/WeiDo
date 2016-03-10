//
//  WDComposeViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD

class WDComposeViewController: UIViewController {
    
    /// emoji界面懒加载
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) -> () in
        self.textView.insertEmoticon(emoticon)
    }
    /// 图片选择器
    private lazy var photoSelectorVC: PhotoSelectorViewController = PhotoSelectorViewController()
    /// 工具条底部约束
    var toolbarBottonCons: NSLayoutConstraint?
    /// 图片选择器高度约束
    var photoViewHeightCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // 注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self , selector: "keyboardChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 将键盘控制器添加为当前控制器的子控制器
        addChildViewController(emoticonVC)
        addChildViewController(photoSelectorVC)
        //初始化导航条 输入框 工具栏
        setupNavigation()
        setupInputView()
        setupPhotoView()
         setupToolbar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 主动唤出键盘
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 主动隐藏键盘
        textView.resignFirstResponder()
    }


    /**
     只要键盘改变就会调用 改变工具条的位置
     */
    func keyboardChange(notify: NSNotification)
    {
      
        // 1.取出键盘最终的rect
        let value = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.CGRectValue()
        
        // 2.修改工具条的约束
     
        let height = UIScreen.mainScreen().bounds.height
        toolbarBottonCons?.constant = -(height - rect.origin.y)
        
        // 3.更新界面
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        // 设置动画  1.取出键盘的动画节奏
        let curve = notify.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animateWithDuration(duration.doubleValue) { () -> Void in
            // 2.设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
            
            self.view.layoutIfNeeded()
        }
        
     //   let anim = toolbar.layer.animationForKey("position")
       
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
  
    /**
     设置工具条
     */
    private func setupToolbar()
    {
        // 1.添加子控件
        view.addSubview(toolbar)
        
        // 2.添加按钮
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
            
            ["imageName": "compose_mentionbutton_background"],
            
            ["imageName": "compose_trendbutton_background"],
            
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            
            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings
        {
           
            
            let item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"])
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
        
        // 3布局toolbar
        let width = UIScreen.mainScreen().bounds.width
        let cons = toolbar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: 44))
        toolbarBottonCons = toolbar.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
    }

    
    /**
     选择相片
     */
    func selectPicture()
    {
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.调整图片选择器的高度
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    func setupPhotoView()
    {
        // 1.添加图片选择器
        view.insertSubview(photoSelectorVC.view, belowSubview: toolbar)
        
        // 2.布局图片选择器
        let size = UIScreen.mainScreen().bounds.size
        let widht = size.width
        let height: CGFloat = 0 // size.height * 0.6
        let cons = photoSelectorVC.view.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: widht, height: height))
        photoViewHeightCons = photoSelectorVC.view.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    

    /**
     切换到表情键盘
     */
    func inputEmoticon()
    {
        
    
        // 1.关闭键盘
        textView.resignFirstResponder()
        
        // 2.设置inputView
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        
        // 3.重新唤出键盘
        textView.becomeFirstResponder()
    }

    
    /**
     初始化输入框
     */
    private func setupInputView()
    {
        // 1.添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 2.布局子控件
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }

    
    /**
     初始化导航条
     */
   private func setupNavigation()
   {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
    navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "compose")
    navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem?.enabled = false
    
    
    }
    
    
    
    func back()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     发送微博
     */
    func compose()
    {
        let text = textView.emoticonAttributedText()
        let image = photoSelectorVC.pictureImages.first
        NetworkTools.shareNetworkTools().compose(text , image: image, successCallback: { (status) -> () in
            // 1.提示用户发送成功
            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            // 2.关闭发送界面
            self.back()
            }) { (error) -> () in
                print(error)
                // 3.提示用户发送失败
                SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
        }
       
        
    
    }

    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "说出你的故事..."
        return label
    }()
    
      private lazy var toolbar: UIToolbar = UIToolbar()
}

extension WDComposeViewController: UITextViewDelegate
{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
