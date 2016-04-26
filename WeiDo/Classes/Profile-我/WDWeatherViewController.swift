//
//  WDWeatherViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/17.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AFNetworking



class WDWeatherViewController: UIViewController, UIGestureRecognizerDelegate {
 
    let weatherApikey = "a790ac2a191a4764f40c2f7986b1cd26"
 //参数
    var params = NSMutableDictionary()
//城市
    var city:String?
//平均温度
    var temp:String?
//最高温度
    var h_tmp:String?
//最低温度
    var l_tmp:String?
//天气情况
    var weather:String?
//风向
    var WD:String?
//风力
    var WS:String?
 
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var h_tmpLabel: UILabel!
    
    @IBOutlet weak var l_tmpLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var WDLabel: UILabel!
    
    @IBOutlet weak var WSLabel: UILabel!
    
    @IBOutlet weak var image_View: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        title = "微天气"
       
       loadWeather()
       
     
     
        
          }
  
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    
   
  
    
    func  loadWeather()
    {
         let path = "http://apis.baidu.com/apistore/weatherservice/weather"
        //获取定位数据不稳定
        if cityname == nil
        {
            cityname = "yangzhou"
        }
        
     let params = ["citypinyin":String(cityname!)]
     let manager =  AFHTTPSessionManager()
        manager.requestSerializer.setValue(weatherApikey, forHTTPHeaderField: "apikey")
        manager.GET(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in
          
            let dataArray = JSON!["retData"] as! NSDictionary
        
             self.city = dataArray.valueForKey("city") as? String
             self.temp = dataArray.valueForKey("temp") as? String
             self.h_tmp = dataArray.valueForKey("h_tmp") as? String
             self.l_tmp = dataArray.valueForKey("l_tmp") as? String
             self.weather = dataArray.valueForKey("weather") as? String
             self.WD = dataArray.valueForKey("WD") as? String
             self.WS = dataArray.valueForKey("WS") as? String
          
             self.cityLabel.text = self.city!
             self.tempLabel.text = "平均气温:\(self.temp!)"
             self.h_tmpLabel.text = "最高温度:\(self.h_tmp!)"
             self.l_tmpLabel.text = "最低温度:\(self.l_tmp!)"
             self.weatherLabel.text = self.weather!
             self.WDLabel.text = self.WD!
             self.WSLabel.text = self.WS!
            
            switch self.weather!
            {
            case "晴" :
                self.image_View.image = UIImage(named: "00")
            case "多云" :
                self.image_View.image = UIImage(named: "01")
            case "阴" :
                self.image_View.image = UIImage(named: "02")
            case "雨" :
                self.image_View.image = UIImage(named: "09")
            default :
                self.image_View.image = UIImage(named: "00")
            }
   
            
            }) { (_, error) -> Void in
                print(error)
        }
    }

}


