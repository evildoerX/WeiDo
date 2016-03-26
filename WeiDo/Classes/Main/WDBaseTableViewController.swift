//
//  WDBaseTableViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDBaseTableViewController: UITableViewController ,WDVistorViewDelegate{

    //判断用户是否登陆
    var didlogin = userAccount.userlogin()
    //保存未登录界面属性
   // var WDVistorView : WDVistorView?
    var vistorView: WDVistorView?
    //保存已登录界面属性
    var loginView :UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //判断用户是否登录来选择进入的控制器
        didlogin ? super.loadView() : loadVistorView()
    }

    override func loadView() {
        
      
        
    }
    
    
    
    
    
    private func loadVistorView()
    {
        let customView = WDVistorView()
    
       view = customView
        customView.delegate = self
        vistorView = customView
    }

    
    // MARK - WDVistorViewDelegate
    
    func loginBtnWillClick() {
        
    //弹出登陆界面
        let oauthView = WDOauthViewController()
        let nav = UINavigationController(rootViewController: oauthView)
        presentViewController(nav, animated: true, completion: nil)
       
    }
    func registerBtnWillClick() {
       
    }
    
   
}
