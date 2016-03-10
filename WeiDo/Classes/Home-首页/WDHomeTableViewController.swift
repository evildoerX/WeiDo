//
//  WDHomeTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

let WDHomeReuseIdentifier = "WDHomeReuseIdentifier"
class WDHomeTableViewController: WDBaseTableViewController {

    /// 保存微博数组
    var statuses: [Status]?
        {
        didSet{
            // 当别人设置完毕数据, 就刷新表格
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !didlogin
            
        {
            vistorView?.setVistorImageView(true, imageName: "visitordiscover_feed_image_house", text: "快快登录开启你的微博之旅吧")
            navigationItem.title = "首页"
            let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
            self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
            return
        }
        //初始化导航条
        setupNavigation()
        
    
        addobserver()
     
        
        // 添加下拉刷新控件
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        //加载微博数据
        loadData()
        
        
        
        
        
    }
    /**
     注册通知, 监听菜单
     */
    func addobserver()
    {
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: WDPopmenuanimationWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: WDPopmenuanimationWilldismiss, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPhotoBrowser:", name: WDStatusPictureViewSelected, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ToCompose", name: WDComposeViewWillAppear, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ToCompose", name: WDRetweetViewWillAppear, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openBrowser:", name: WDOpenBrowser, object: nil)
        
        // 注册两个cell
        tableView.registerClass(WDNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(WDForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    
    /**
     打开网页
     */
    func openBrowser(notify: NSNotification)
    {
        guard let urls = notify.userInfo![WDOpenBrowser] as? String else
        {
            return
        }
        print(urls)
        let url = NSURL(string: urls)
        let request = NSURLRequest(URL: url!)
        
        let vc = WDWebBrowserViewController(request:request)
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
      
        
    }
    
    /**
     发送评论

     */
    func ToCompose()
    {
     
     let nav = UINavigationController()
    let vc = WDComposeViewController()
        nav.addChildViewController(vc)
        presentViewController(nav, animated: true, completion: nil)
      
    
    }
    
 
    
    /**
     显示图片浏览器
     */
    
    func showPhotoBrowser(notify: NSNotification)
    {
      /// 如果通过通知传递数据一定要判断数据是否存在
      guard let indexPath = notify.userInfo![WDStatusPictureViewIndexKey] as? NSIndexPath else
      {
           return
        }
        
        guard let urls = notify.userInfo![WDStatusPictureViewURLsKey] as? [NSURL]  else
        {
          return
        }
        
      
        
        //创建控制器
        let vc = PhotoBrowserViewController(index: indexPath.item, urls: urls)
        // 显示控制器
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false
   /**
     获取微博数据
     */
    @objc private func loadData()
    {
        /*
        1.默认最新返回20条数据
        2.since_id : 会返回比since_id大的微博
        3.max_id: 会返回小于等于max_id的微博
        
        每条微博都有一个微博ID, 而且微博ID越后面发送的微博, 它的微博ID越大
        递增

        
        */
        // 1.默认当做下拉处理
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        // 2.判断是否是上拉
        if pullupRefreshFlag
        {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatuses(since_id, max_id: max_id) { (models, error) -> () in
            
            // 接收刷新
            self.refreshControl?.endRefreshing()
            
            if error != nil
            {
                return
            }
            // 下拉刷新
            if since_id > 0
            {
                // 如果是下拉刷新, 就将获取到的数据, 拼接在原有数据的前面
                self.statuses = models! + self.statuses!
                
                // 显示刷新提醒
                self.showNewStatusCount(models?.count ?? 0)
            }else if max_id > 0
            {
                // 如果是上拉加载更多, 就将获取到的数据, 拼接在原有数据的后面
                self.statuses = self.statuses! + models!
            }
            else
            {
                self.statuses = models
            }
        }
    }

    /**
     显示刷新提醒
     */
    private func showNewStatusCount(count : Int)
    {
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            
            }) { (_) -> Void in
                UIView.animateWithDuration(2, animations: { () -> Void in
                    self.newStatusLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.newStatusLabel.hidden = true
                })
        }
    }
    
    
    /**
     修改标题按钮的状态
     */
    func change(){
        // 修改标题按钮的状态
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    
    /**
     设置主页左右nav的按钮
     */
    private func setupNavigation()
    {
        //设置主页左右nav的按钮
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("friendsRecommentIcon", target: self, action: "leftBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightBtnClick")
        //设置标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("Bubble-luliangxiao ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    /**
     标题按钮监听
     */
    func titleBtnClick(btn: TitleButton)
    {
        
        //加载下拉框
        let sb = UIStoryboard(name: "Popmenu", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        //设置动画
        
        vc?.transitioningDelegate = popmenuanimation
        
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    /**
     左边按钮监听
     */
    func leftBtnClick()
    {
        let vc = WDFriendViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
    /**
     右边按钮监听
     */
    func rightBtnClick()
    {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func backToHome()
    {
     dismissViewControllerAnimated(true, completion: nil)
      
    }
    
 
    
    // MARK - 懒加载动画
    private lazy var popmenuanimation:WDPopmenuanimation =  {
        
        let pa  = WDPopmenuanimation()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
        
    }()
    
    
    /// 刷新提醒控件
    private lazy var newStatusLabel: UILabel =
    {
        let label = UILabel()
        let height: CGFloat = 44
        label.frame =  CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        
        label.backgroundColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 1.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        label.hidden = true
        return label
    }()
    
  

    
    /// 微博行高的缓存, 利用字典作为容器. key就是微博的id, 值就是对应微博的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
}


extension WDHomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let status = statuses![indexPath.row]
    
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! WDStatusTableViewCell
        // 2.设置数据
        cell.status = status
        
        
        // 4.判断是否滚动到了最后一个cell
        let count = statuses?.count ?? 0
        if indexPath.row == (count - 1)
        {
            pullupRefreshFlag = true
            //            print("上拉加载更多")
            loadData()
        }

        
        // 3.返回cell
        return cell    }
    
    
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.取出对应行的模型
        let status = statuses![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id]
        {
            
            return height
        }
        
        // 3.拿到cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! WDStatusTableViewCell
        
        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
        
        
        // 6.返回行高
        return rowHeight
    }
 
}


