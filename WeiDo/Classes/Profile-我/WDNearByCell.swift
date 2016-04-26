//
//  WDNearByCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/16.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage


class WDNearByCell: UITableViewCell {

    
    @IBOutlet weak var profile_view: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var follower: UILabel!
    
    @IBOutlet weak var follow: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var descripitonLabel: UILabel!
    
    @IBOutlet weak var gender: UIImageView!
    
    var nearby:WDNearby?
        {
    
        didSet{
            profile_view.sd_setImageWithURL(NSURL(string: (nearby?.profile_image_url!)!))
            nameLabel.text = nearby!.screen_name!
            follower.text = "粉丝:\(nearby!.followers_count!)"
            follow.text = "关注:\(nearby!.friends_count!)"
            distance.text = "距离我\(nearby!.distacnce!)米"
            descripitonLabel.text = nearby!.Description!
            
            /**
            *  判断男女
            */
            if nearby?.gender == "m"
            {
             gender.image = UIImage(named: "Profile_manIcon")
            }
            else
            {
              gender.image = UIImage(named: "Profile_womanIcon")
            }
            /**
            设置图为圆角
            */
            profile_view.kay_addCorner(radius: profile_view.frame.width / 2)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    class func nearbyCell() -> WDNearByCell{
        return NSBundle.mainBundle().loadNibNamed("WDNearByCell", owner: nil, options: nil)[0] as! WDNearByCell
    }
    
}
