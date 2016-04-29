//
//  WDVideoCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

let WDVideoWillPlay = "WDVideoWillPlay"
let WDVideoShare = "WDVideoShare"
let WDVideotextShare = "WDVideotextShare"
class WDVideoCell: UITableViewCell {
    
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var create_time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var play_count: UILabel!
    
    @IBOutlet weak var videotime: UILabel!
    
    @IBOutlet weak var dingBtn: UIButton!
    
    
    @IBOutlet weak var caiBtn: UIButton!
    
    @IBOutlet weak var repostBtn: UIButton!

    @IBOutlet weak var commentBtn: UIButton!
    
    var videoTopic:WDTopic?
        {
        didSet{
            profile_image.sd_setImageWithURL(NSURL(string: (videoTopic?.profile_image)!))
            name.text = videoTopic?.name
           
            create_time.text = videoTopic?.create_time
            name.textColor = DFColor
            content.text = videoTopic?.text
            image_view.sd_setImageWithURL(NSURL(string: (videoTopic?.cdn_img)!))
          
            
            let minute = Int(videoTopic!.videotime!)! / 60
            let second = Int(videoTopic!.videotime!)! % 60
            videotime.text = NSString.init(format: "%02d:%02d",minute,second) as String
            videotime.textColor = UIColor.whiteColor()
            dingBtn.setTitle(String(videoTopic!.ding), forState: UIControlState.Normal)
            caiBtn.setTitle(String(videoTopic!.cai), forState: UIControlState.Normal)
            repostBtn.setTitle(String(videoTopic!.repost), forState: UIControlState.Normal)
            commentBtn.setTitle(String(videoTopic!.comment), forState: UIControlState.Normal)
        
       
            
            /**
            设置图为圆角
            */
            profile_image.kay_addCorner(radius: profile_image.frame.width / 2)
        }
    
    }
    
    
    
    @IBAction func playClick(sender: AnyObject) {
        
        
        let info = [WDVideoWillPlay:videoTopic!.videouri!]
      NSNotificationCenter.defaultCenter().postNotificationName(WDVideoWillPlay, object: self, userInfo: info)
       
        
    }
    

    @IBAction func shareClick(sender: AnyObject) {
        
        let info = [WDVideoShare:videoTopic!.videouri!,WDVideotextShare:videoTopic!.text]
        NSNotificationCenter.defaultCenter().postNotificationName(WDVideoShare, object: self, userInfo: info)
    }
    
    
   


    
}
