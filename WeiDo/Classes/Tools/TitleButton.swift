//
//  TitleButton.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/3.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
      
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
//        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        self.sizeToFit()
         
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width

    }
}
