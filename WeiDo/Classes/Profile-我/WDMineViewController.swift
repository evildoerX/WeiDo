//
//  WDMineViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking
import SVProgressHUD


let MyStatusCellReuseIdentifier = "WDMyStatusCell"
class WDMineViewController: UIViewController{
    
  
    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
    var vistorView: WDVistorView?
  
    
    
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
   
    @IBOutlet weak var profileimageView: UIImageView!
    
    @IBOutlet weak var statusCountLabel: UILabel!
    
    @IBOutlet weak var followLabel: UILabel!
    
    @IBOutlet weak var follerLabel: UILabel!

   
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !didlogin
            
        {
           setupVistorView()
            setupNavigation()
        }
        else

        {
            
            loadMineData()
      
        }
      
    }
    
    /**
     未登录界面
     */
   func setupVistorView()
    {
        
        
        
        let imageView = UIImageView(image: UIImage(named: "HomePage_DefaultBackground"))
        view.addSubview(imageView)
        view.addSubview(loginBtn)
        imageView.xmg_Fill(view)
        loginBtn.xmg_AlignVertical(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 92, height: 36), offset: CGPoint(x: 0, y: 130))
    
    }
    
    /**
     设置导航条
     */
    func setupNavigation()
    {
        navigationItem.title = "我"
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
       
    }
    
    /**
     加载个人信息
     */
   func loadMineData()
    {
    let path = "https://api.weibo.com/2/users/domain_show.json"
       let params = ["access_token": userAccount.loadAccount()!.access_token!, "domain": "w535921901"]
        let manager = AFHTTPSessionManager()
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            
            self.follerLabel.text = String(JSON!["followers_count"])
            self.followLabel.text = String(JSON!["friends_count"])
            self.statusCountLabel.text = String(JSON!["statuses_count"])
            self.locationLabel.text = String(JSON!["location"])
            self.nameLabel.text = String(JSON!["screen_name"])
            self.profileimageView.sd_setImageWithURL(NSURL(string: String(JSON!["avatar_large"])))
            
            
            }) { (_, error) -> Void in
                print(error)
        }
        
        
    }
  
  
    
    /**
     我的微博点击

     */
    @IBAction func toMyStatusClick(sender: AnyObject) {
  let vc = WDMyStatusController()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    /**
     清除缓存
     
     
     */
    @IBAction func cleanCache(sender: AnyObject) {
        StatusDAO.cleanCahcheStatuses()
        SVProgressHUD.showSuccessWithStatus("清除成功！")
        
    }
    
    /**
     联系我们
     */
    @IBAction func call(sender: AnyObject) {
        
     UIApplication.sharedApplication().openURL(NSURL(string :"sms://18205254911")!)
        
    }
    
    
    func loginClick()
    {
        
        let oauthView = WDOauthViewController()
        let nav = UINavigationController(rootViewController: oauthView)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
 // MARK: - 懒加载
    
    private lazy var loginBtn: UIButton =
    {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "登录按钮背景"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()

  
    
}
