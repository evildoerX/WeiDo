//
//  WDVideoCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

let WDVideoWillPlay = "WDVideoWillPlay"
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
            name.textColor = bgcolor
            create_time.text = videoTopic?.create_time
            create_time.textColor = bgcolor
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
        
            //添加手势
            content.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "commentClick")
            content.addGestureRecognizer(tap)
     
            
            /**
            设置图为圆角
            */
            profile_image.layer.masksToBounds = true
            profile_image.layer.cornerRadius = (profile_image.frame.width / 2)
        }
    
    }
    
    
    
    @IBAction func playClick(sender: AnyObject) {
        
        
        let info = [WDVideoWillPlay:videoTopic!.videouri!]
      NSNotificationCenter.defaultCenter().postNotificationName(WDVideoWillPlay, object: self, userInfo: info)
       
        
    }
    
    func commentClick()
        
    {
       
        let info = [WDCommentWillOpen:videoTopic!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDCommentWillOpen, object: self, userInfo: info)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
         backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        
        
    }


    class func videoCell() -> WDVideoCell{
        return NSBundle.mainBundle().loadNibNamed("WDVideoCell", owner: nil, options: nil)[0] as! WDVideoCell
    }

    
    
    
    
    
    
    
}
