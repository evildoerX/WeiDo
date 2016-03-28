//
//  WDMineDataViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/12.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking

let MyStatusCellReuseIdentifier = "WDMyStatusCell"
class WDMineDataViewController: UIViewController, UIGestureRecognizerDelegate {

    /// 数据源
    var mineStatus = [WDMineStatus]()
    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
    var vistorView: WDVistorView?

    
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
            setupTableview()
            loadMineData()
            loadMyStatus()
            
        }
        setupNavigation()
  //      sweptBack()
        
       

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    /**
     滑动返回
     */
    func sweptBack()
    {
        let target = navigationController?.interactivePopGestureRecognizer?.delegate

        let pan = UIPanGestureRecognizer(target: target, action: "handleNavigationTransition:")
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        navigationController?.interactivePopGestureRecognizer?.enabled = false

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
        tableview.registerNib(UINib(nibName: "WDMyStatusCell", bundle: nil), forCellReuseIdentifier: MyStatusCellReuseIdentifier)
        tableview.estimatedRowHeight = 300
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    /**
     设置导航条
     */
    func setupNavigation()
    {
        navigationItem.title = "我的"
    //     navigationItem.leftBarButtonItem = UIBarButtonItem.createBackBarButtonItem(self, action: #selector(WDMineDataViewController.back))
  //      self.tabBarController?.tabBar.hidden = true
        
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
            
            self.followerCountLabel.text = String(JSON!["followers_count"])
            self.followCountLabel.text = String(JSON!["friends_count"])
            self.statusCountLabel.text = String(JSON!["statuses_count"])
            self.locationLabel.text = String(JSON!["location"])
            self.nameLabel.text = String(JSON!["screen_name"])
            self.despcritionLabel.text = String(JSON!["description"])
            self.image_view.sd_setImageWithURL(NSURL(string: String(JSON!["avatar_large"])))
            print(JSON!["avatar_large"])
            /**
            *  设置图片为圆角
            */
            self.image_view.layer.masksToBounds = true
            self.image_view.layer.cornerRadius = (self.image_view.frame.width / 2)
            
            
            }) { (_, error) -> Void in
                print(error)
                
                
        }
        
        
    }
    
    /**
     加载我的微博
     */
    func loadMyStatus()
    {
        let path = "https://api.weibo.com/2/statuses/user_timeline.json"
        let params = ["access_token": userAccount.loadAccount()!.access_token!]
        let manager = AFHTTPSessionManager()
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            let myStatusarray = JSON!["statuses"] as! [[String:AnyObject]]
            
            self.mineStatus = WDMineStatus.LoadMine(myStatusarray)
            self.tableview.reloadData()

            }) { (_, error) -> Void in
 
            self.setupVistorView()
            
        }

    }
    
    
    func back()
    {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginClick()
    {
        let oauthView = WDOauthViewController()
        let nav = UINavigationController(rootViewController: oauthView)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    /**
     判断是否滑动返回
     */
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1
        {
            return false
        }
        return true
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

extension WDMineDataViewController: UITableViewDelegate
{
  
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mineStatus.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MyStatusCellReuseIdentifier, forIndexPath: indexPath) as! WDMyStatusCell
        let myStatuesCell = mineStatus[indexPath.row]
        cell.mineStatus = myStatuesCell
        return cell
    }
    
     func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "我的微博"
    }
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  30
    }
    
     func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.whiteColor()
    }
    
}
