//
//  WDCommentComposeViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/14.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

class WDCommentComposeViewController: UIViewController {

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
    /// 评论id
    var commentId: Int?
    /// 微博id
    var statusId: Int?
    /// 按钮的状态
    var btnState:Int?
    /**  当前正在请求的参数  */
    var params = NSMutableDictionary()
    
    
    
    init(commentid: Int, state:Int, statusid:Int)
    {
        self.statusId = statusid 
        self.btnState = state
        self.commentId = commentid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // 注册通知监听键盘弹出和消失
        NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(WDCommentComposeViewController.keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 将键盘控制器添加为当前控制器的子控制器
        addChildViewController(emoticonVC)
        addChildViewController(photoSelectorVC)
        //初始化导航条 输入框 工具栏
        
        setupNavigation()
        setupInputView()
  

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
        
        
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    {     navigationController?.navigationBar.setBackgroundImage(UIImage(named: "login_register_background"), forBarMetrics: UIBarMetrics.Default)
        navigationItem.titleView = iconImageView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WDCommentComposeViewController.back))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        
        
        /**
        *  判断是转发还是评论
        */
        if self.btnState == 1
        {
            addBtn("评论")
        }
        else if self.btnState == 2
        {
            addBtn("转发")
        }
        
        else
        {
           addBtn("回复")
        
        }
     
        
        
    }
    //添加按钮
    func addBtn(title:String)
  {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WDCommentComposeViewController.compose))
    navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func back()
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    func compose()
     {
        var path = ""
      let text = textView.emoticonAttributedText()
        var params = [String:AnyObject]()
        params["access_token"] = userAccount.loadAccount()!.access_token!
        //评论
      if self.btnState == 1
      {
         path = "https://api.weibo.com/2/comments/create.json"
        params["comment"] = text
        params["id"] = commentId
      }
        //转发
      else if self.btnState == 2
      {
       path = "https://api.weibo.com/2/statuses/repost.json"
        params["status"] = text
        params["id"] = commentId
      }
        //回复
      else
      {
       path = "https://api.weibo.com/2/comments/reply.json"
        params["cid"] = commentId
        params["id"] = statusId
        params["comment"] = text
        }
        
        self.params.setDictionary(params)
        let manager = AFHTTPSessionManager()

        manager.POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            
            SVProgressHUD.showSuccessWithStatus("发送成功", maskType: SVProgressHUDMaskType.Black)
            self.back()
            
            
        }) { (_, error) -> Void in
            print(error)
            SVProgressHUD.showErrorWithStatus("发送失败", maskType: SVProgressHUDMaskType.Black)
        }

    
    }

    
    // MARK: - 懒加载
    
    private lazy var iconImageView: UIImageView =
        {
            let imageurl = userAccount.loadAccount()!.avatar_large!
            
            let image = UIImageView(frame: CGRectMake(0, 0, 90, 90))
            image.clipsToBounds = true
            image.layer.cornerRadius = image.frame.height / 2
            
            image.sd_setImageWithURL(NSURL(string: imageurl))
            return image
    }()

    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.text = "大胆的发表言论吧..."
        return label
    }()
    
    private lazy var toolbar: UIToolbar = UIToolbar()
}

extension WDCommentComposeViewController: UITextViewDelegate
{
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}