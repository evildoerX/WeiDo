//
//  WDMineDataViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/12.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

let MyStatusCellReuseIdentifier = "WDMyStatusCell"
class WDMineDataViewController: UIViewController {

    /// 数据源
    var mineStatus = [WDMineStatus]()
    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
    var vistorView: WDVistorView?

    var dataSource:WDDataSource?
    
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var despcritionLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var followCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var statusCountLabel: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func editClick(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !didlogin
            
        {
            setupVistorView()
            
        }
        else
            
        {
            
            loadMineData()
            loadMyStatus()
            
          
            
        }
         navigationItem.title = "我的"
  
        
       

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
   
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
    
    
    func setupTableview()
    {
        
        let cellConfig: tableViewCellConfigure =  { (cell:AnyObject, item:AnyObject) in
            
            let _cell = cell as! WDMyStatusCell
            let _item = item as! WDMineStatus
            _cell.mineStatus = _item
        }
        
        self.dataSource = WDDataSource(items: mineStatus, cellIdentifier: MyStatusCellReuseIdentifier, cellConfigure: cellConfig)
        
        tableview.dataSource = self.dataSource
        tableview.estimatedRowHeight = 300
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.registerNib(UINib(nibName: "WDMyStatusCell", bundle: nil), forCellReuseIdentifier: MyStatusCellReuseIdentifier)

        
    }
  
    /**
     加载个人信息
     */
    func loadMineData()
    {
        let path = "https://api.weibo.com/2/users/domain_show.json"
        //个人信息通过个人域名修改 若换号需要修改信息
        let params = ["access_token": userAccount.loadAccount()!.access_token!, "domain": "w535921901"]
        let manager = AFHTTPSessionManager()
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            
            self.followerCountLabel.text = String(JSON!["followers_count"])
            self.followCountLabel.text = String(JSON!["friends_count"])
            self.statusCountLabel.text = String(JSON!["statuses_count"])
            self.locationLabel.text = String(JSON!["location"])
            self.nameLabel.text = String(JSON!["screen_name"])
            self.despcritionLabel.text = String(JSON!["description"])
            self.image_view.sd_setImageWithURL(NSURL(string: String(JSON!["avatar_large"])))
            
            /**
            *  设置图片为圆角
            */
            self.image_view.kay_addCorner(radius: self.image_view.frame.width / 2)
 
            
            }) { (_, error) -> Void in
                print(error)
                SVProgressHUD.showErrorWithStatus("网络似乎有点问题")
                
        }
        
        
    }
    
    /**
     加载我的微博
     */
    func loadMyStatus()
    {

        let params = ["access_token": userAccount.loadAccount()!.access_token!]
        WDMineStatus.loadMineData(params) { (models, error) in
            if error != nil
            {
             self.setupVistorView()
            
            }
            else
            {
            self.mineStatus = models!
            self.setupTableview()
            self.tableview.reloadData()
            }
        }
        
        
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
        btn.addTarget(self, action: #selector(WDMineDataViewController.loginClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()



  

}

