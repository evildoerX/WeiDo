//
//  WDPulblishViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/15.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class WDPulblishViewController: UIViewController {

    @IBOutlet weak var titleView: UIImageView!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var repostBtn: UIButton!
    
    /// 传递的id数据
    var passbyID :Int?
    /**
     按钮状态   1是评论  2是转发
     */
    var btnState:Int?
    
    init(id: Int)
    {
        
        self.passbyID = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.userInteractionEnabled = false
        self.buttonView.transform = CGAffineTransformMakeTranslation(0, -500)
        self.titleView.transform = CGAffineTransformMakeTranslation(200, -200)
    
       
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 10,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                self.buttonView.transform = CGAffineTransformIdentity
                self.titleView.transform = CGAffineTransformIdentity
                
            }) { (bool:Bool) -> Void in
                self.view.userInteractionEnabled = true
        }

    }
    
    
    func back()
    {
        
        self.view.userInteractionEnabled = false
        
        self.buttonView.transform = CGAffineTransformIdentity
        self.titleView.transform = CGAffineTransformIdentity
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.buttonView.transform = CGAffineTransformMakeTranslation(0, 500)
            self.titleView.transform = CGAffineTransformMakeTranslation(0, 700)
            }) { (bool:Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
        }

    }
   
    @IBAction func backClick(sender: AnyObject) {
        
       back()

    }

    @IBAction func commentClick(sender: AnyObject) {
      self.btnState = 1
        let vc = WDCommentComposeViewController(commentid:passbyID!, state:btnState!,statusid: 1) //不需要statusid 可以随便传
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
   
    @IBAction func likeClick(sender: AnyObject) {
        
        //收藏
        let path = "https://api.weibo.com/2/favorites/create.json"
        let params = ["access_token":userAccount.loadAccount()!.access_token!,"id":passbyID!]
        AFHTTPSessionManager().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            SVProgressHUD.showSuccessWithStatus("收藏成功!", maskType: SVProgressHUDMaskType.Black)
            }) { (_, error) -> Void in
                print(error)
                SVProgressHUD.showErrorWithStatus("收藏失败", maskType: SVProgressHUDMaskType.Black)

        }
        

       
        
      
    }
  
    @IBAction func retweetClick(sender: AnyObject) {
        self.btnState = 2
        let vc = WDCommentComposeViewController(commentid:passbyID!, state:btnState!,statusid: 1) //不需要statusid 可以随便传
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       back()
    }

}
