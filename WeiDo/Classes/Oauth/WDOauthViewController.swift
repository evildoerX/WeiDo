//
//  WDOauthViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/5.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD

class WDOauthViewController: UIViewController {
    /// 用户登录信息


    
    let app_key = "1649214170"
    let app_secret = "e1a8c149d140eda21ccec829de19521b"
      let redirect_uri = "http://sns.whalecloud.com/sina2/callback"
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化导航条
        navigationItem.title = "WeiDo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WDOauthViewController.backClick))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        
        
        //获取未授权的requested token
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    
    
    
    func backClick()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func loadView() {
        view = webView
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载ing...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        
    }
    
    private lazy var webView:UIWebView =
    {
        let wv = UIWebView()
        wv.delegate = self
        return wv
        
    }()
    
}

extension WDOauthViewController: UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        // print(request.URL?.absoluteString)
        
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(redirect_uri)
        {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            // 授权成功
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        }else
        {
            // 取消授权
            // 关闭界面
            backClick()
        }
        
        return false
    }
    
  
    
    
    /**
     换取AccessToken
     
     - parameter code: 授权回调密码
     */
    private func loadAccessToken(code: String)
    {
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":app_key, "client_secret":app_secret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirect_uri]
        // 3.发送POST请求
        
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            // 1.字典转模型
            let account = userAccount(dict: JSON as! [String : AnyObject])
            // 2.获取用户信息
            account.loadUserInfo { (account, error) -> () in
                if account != nil
                {
                    account!.saveAccount()
                    // 去欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(WDSwitchRootViewControllerKey, object: false)
                //    让背景消失
                    self.presentViewController(UIViewController(), animated: true, completion: nil)
                    
                    
                    return
                }
                
                SVProgressHUD.showInfoWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Black)
            }
            }) { (_, error) -> Void in
                
                print(error)
                
        }
    }
}