//
//  WDTravelCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/20.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDTravelCell: UITableViewCell {

    @IBOutlet weak var titleImageview: UIImageView!
    
    @IBOutlet weak var userHeaderImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var routeDayLabel: UILabel!
    

    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
        var travel:WDTravel?
        {
        didSet{
            
            titleImageview.sd_setImageWithURL(NSURL(string: travel!.headImage!))
            userHeaderImageView.sd_setImageWithURL(NSURL(string: travel!.userHeadImg!))
            titleLabel.text = travel!.title
            routeDayLabel.text = "\(travel!.startTime!)出发|共\(travel!.routeDays!)天"
            likeCountLabel.text = "喜欢\(travel!.likeCount!)"
            commentCountLabel.text = "评论\(travel!.commentCount!)"
            /**
            设置图为圆角
            */
            userHeaderImageView.layer.masksToBounds = true
            userHeaderImageView.layer.cornerRadius = (userHeaderImageView.frame.width / 2)
            
   

        
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
    
}
