//
//  WDNewsCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage




class WDNewsCell: UITableViewCell {
    

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createtimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var newsImageView: UIImageView!
    
    var sportnew:WDNews?
        {
        didSet{

        setData(sportnew)
  
        }
    
    }
    
    
    var amusementnew:WDNews?
        {
        didSet{
            
           setData(amusementnew)
            
    
        }
    }
    
    var technologynew:WDNews?
        {
        didSet{
            
            setData(technologynew)

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
    
    /**
     加载数据
     */
    func setData(new:WDNews?)
    {
        newsImageView.sd_setImageWithURL(NSURL(string: (new?.picUrl)!))
        titleLabel?.text = new?.newsDescription
        descriptionLabel.text = new?.title
        createtimeLabel.text = new?.ctime
    }
    

    
    
       
    
}
