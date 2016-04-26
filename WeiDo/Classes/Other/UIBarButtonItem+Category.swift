//
//  UIBarButtonItem+Category.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    class func   createBarButtonItem(imageName:String , target:AnyObject? , action:Selector) ->UIBarButtonItem
    {
    
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
       
    }
    
    
    class func   createBackBarButtonItem(target:AnyObject? , action:Selector) ->UIBarButtonItem
    {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "button_back_white"), forState: UIControlState.Normal)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
        
    }

   
}
