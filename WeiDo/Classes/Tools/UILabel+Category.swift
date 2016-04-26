//
//  UILabel+Category.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/9.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

extension UILabel
{
    class func createLabel(color:UIColor, fontsize:CGFloat)  ->UILabel{
        
        let label = UILabel()
        label.textColor = bgcolor
        label.font = UIFont.systemFontOfSize(fontsize)
        return label
    }

}
