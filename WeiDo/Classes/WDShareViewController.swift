//
//  WDShareViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/1.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import OpenShare

class WDShareViewController: UIViewController {

    var type:Int? // 文本是1 图片是2 视频url是3  新闻是4
    var text:String?
   
    var url:String?
    
    var message = OSMessage()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var buttonview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.userInteractionEnabled = false
        self.buttonview.transform = CGAffineTransformMakeTranslation(0, -500)
        self.titleLabel.transform = CGAffineTransformMakeTranslation(200, -200)
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 10,
                                   options: .CurveEaseInOut,
                                   animations: { () -> Void in
                                    self.buttonview.transform = CGAffineTransformIdentity
                                    self.titleLabel.transform = CGAffineTransformIdentity
                                    
        }) { (bool:Bool) -> Void in
            self.view.userInteractionEnabled = true
        }
        
    }

    
    func back()
    {
        
        self.view.userInteractionEnabled = false
        
        self.buttonview.transform = CGAffineTransformIdentity
        self.titleLabel.transform = CGAffineTransformIdentity
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.buttonview.transform = CGAffineTransformMakeTranslation(0, 500)
            self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 700)
        }) { (bool:Bool) -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }


    init(type:Int,text:String?,url:String?)
  {
    
    self.type = type

    self.text = text
 
    self.url = url
    
    super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        back()
    }

    @IBAction func qqFriendClick(sender: AnyObject) {
     
        
  
        chooseTitle()
        
        
        OpenShare.shareToQQFriends(message, success: { (message) in
            
            }, fail: { (message, error) in
                print(error)
        })

    }
    
    @IBAction func friendLineClick(sender: AnyObject) {
        
        chooseTitle()

        
        
        OpenShare.shareToWeixinTimeline(message, success: { (message) in
            
            }, fail: { (message, error) in
                print(error)
        })
        
    }
    
    @IBAction func weChatFriendClick(sender: AnyObject) {
        
        chooseTitle()

        OpenShare.shareToWeixinSession(message, success: { (message) in
            
            }, fail: { (message, error) in
                print(error)
        })

        
    }
   
    @IBAction func back(sender: AnyObject) {
        
      back()

    }
    
    
    func  chooseTitle()
    {
        let endtitle = "-来自 WeiDo 客户端"
        
        if self.type == 1 {
            
            message.title =  text! + " ________文字分享" +  endtitle
        }
        else if self.type == 2
        {
            message.title = url!  + text! + " ________图片分享" +  endtitle
        }
        else if self.type == 3
        {
            message.title = url!  + text! + " ________视频分享" +  endtitle
        }
            
        else
        {
            message.title =  text!
        }
    }
    
}
