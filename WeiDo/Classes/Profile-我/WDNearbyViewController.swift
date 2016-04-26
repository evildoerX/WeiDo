//
//  WDNearbyViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/16.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation



class WDNearbyViewController: UIViewController, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var rockup: UIImageView!
    @IBOutlet weak var rockdown: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var params = NSMutableDictionary()
 
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        /**
        开启摇动感应
        */
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        becomeFirstResponder()
        
   
  
    
    }
    
  
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }

    func setupUI()
    {
        self.tabBarController?.tabBar.hidden = true
        title = "摇一摇"
        addressLabel.text = currAddress
        locationLabel.text = currLocationName
    }
    
   
    
       /**
     开始摇动
     */
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("开始摇动")
        
        //开始动画
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.rockup.frame.origin.y -= 80
            self.rockdown.frame.origin.y += 80
            
            }, completion: nil)
        /// 设置音效
        let path1 = NSBundle.mainBundle().pathForResource("rock", ofType:"mp3")
        let data1 = NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1!)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        
        //结束动画
        UIView.animateKeyframesWithDuration(0.5, delay: 1.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.rockup.frame.origin.y += 80
            self.rockdown.frame.origin.y -= 80
            
            }, completion: nil)

    }
    /**
     取消摇动
     
    
     */
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("取消摇动")
        SVProgressHUD.showErrorWithStatus("还不够用力哦 请使劲的摇我吧", maskType: SVProgressHUDMaskType.Black)
    }
    
    /**
     摇动结束
     
     */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("摇动结束")

         let vc = WDLoadNearByTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        /// 设置音效
        let path = NSBundle.mainBundle().pathForResource("rock_end", ofType:"mp3")
        let data = NSData(contentsOfFile: path!)
        self.player = try? AVAudioPlayer(data: data!)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
    }


}
