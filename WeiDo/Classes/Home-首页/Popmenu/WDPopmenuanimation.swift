//
//  WDPopmenuanimation.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

// 定义常量保存通知的名称
let WDPopmenuanimationWillShow = "WDPopmenuanimationWillShow"
let WDPopmenuanimationWilldismiss = "WDPopmenuanimationWilldismiss"

class WDPopmenuanimation: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
    

{
    /// 记录当前是否是展开
    var isPresent: Bool = false
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        let pc = WDPopmenuPresentationController(presentedViewController: presented, presentingViewController: presenting)
        // 设置菜单的大小
        pc.presentFrame = presentFrame
        return pc
    }

    
    /**
     告诉系统谁来负责modal动画
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        // 发送通知, 通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(WDPopmenuanimationWillShow, object: self)
        return self
      
    }
    /**
     告诉系统谁来负责modal动画的消失
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
         NSNotificationCenter.defaultCenter().postNotificationName(WDPopmenuanimationWilldismiss, object: self)
        return self
    }
    
    // MARK -UIViewControllerAnimatedTransitioning代理的方法
    
    /**
    返回动画时长
    
    - parameter transitionContext: 上下文，保存动画需要的所有参数
    
    - returns: 动画时长
    */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
        
    }
    /**
     告诉系统如何动画
     
     - parameter transitionContext: 上下文，保存动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
       
        if isPresent
        {
            // 展开
           
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
            
            // 注意: 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            // 设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 2.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 2.1清空transform
                toView.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    // 2.2动画执行完毕, 一定要告诉系统
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            }
        }else
        {
            // 关闭
         
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
              
                // 压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
              
                    transitionContext.completeTransition(true)
            })
        }
    }
}