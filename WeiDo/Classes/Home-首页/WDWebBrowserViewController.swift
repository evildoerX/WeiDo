//
//  WDWebBrowserViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/9.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD


class WDWebBrowserViewController: UIViewController, UIWebViewDelegate {
    
 
    var urlRequest: NSURLRequest?
 
    init(request:NSURLRequest)
    {
        // Swift语法规定, 必须先初始化本类属性, 再初始化父类
        urlRequest = request
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let wv = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 88))
            navigationItem.leftBarButtonItem = UIBarButtonItem.createBackBarButtonItem(self, action: "back")
        wv.loadRequest(urlRequest!)
        view = wv
        wv.delegate = self
        
    }

    
    func back()
    {
       dismissViewControllerAnimated(true, completion: nil)
    }

    
   
  
}
