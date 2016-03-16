//
//  WDQRCodeViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AVFoundation

class WDQRCodeViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var scanlineImageView: UIImageView!
    //容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //扫描线约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    /// 底部视图
    @IBOutlet weak var customTabBar: UITabBar!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        // 1.设置底部视图默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func myCardClick(sender: AnyObject) {
        let vc = WDQRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //开始动画
        startAnimation()
        //开始扫描
        startScan()
    }
    /**
     动画实现方法
     */
    func startAnimation()
    {

        UIView.animateWithDuration(0.9, animations: { () -> Void in
            
            self.scanLineCons.constant = 300
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanlineImageView.layoutIfNeeded()
            }, completion: nil)

        self.scanLineCons.constant = 10
    }
    /**
     扫描实现方法
     */
    func startScan()
   {
    // 1.判断是否能够将输入添加到会话中
    if !session.canAddInput(deviceInput)
    {
        return
    }
    // 2.判断是否能够将输出添加到会话中
    if !session.canAddOutput(output)
    {
        return
    }
    // 3.将输入和输出都添加到会话中
    session.addInput(deviceInput)
    print(output.availableMetadataObjectTypes)
    session.addOutput(output)
    print(output.availableMetadataObjectTypes)
    
    // 4.设置输出能够解析的数据类型
    // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
    output.metadataObjectTypes =  output.availableMetadataObjectTypes
    print(output.availableMetadataObjectTypes)
    // 5.设置输出对象的代理, 只要解析成功就会通知代理
    output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    // 如果想实现只扫描一张图片, 那么系统自带的二维码扫描是不支持的
    // 只能设置让二维码只有出现在某一块区域才去扫描
    //        output.rectOfInterest = CGRectMake(0.0, 0.0, 1, 1)
    
    // 添加预览图层
    view.layer.insertSublayer(previewLayer, atIndex: 0)
    
    // 添加绘制图层到预览图层上
    previewLayer.addSublayer(drawLayer)
    
    // 6.告诉session开始扫描
    session.startRunning()
    
    }
    
    
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // 1.修改容器的高度
        if item.tag == 1{
            //
            self.containerHeightCons.constant = 300
        }else{
           
            self.containerHeightCons.constant = 150
        }
        
        // 2.停止动画
        self.scanlineImageView.layer.removeAllAnimations()
        
        // 3.重新开始动画
        startAnimation()
    }
    

    
   
    // MARK: - 懒加载
    // 会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    // 拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        // 获取摄像头
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            // 创建输入对象
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch
        {
            print(error)
            return nil
        }
    }()
    
    // 拿到输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    // 创建用于绘制边线的图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()

  
}


extension WDQRCodeViewController:AVCaptureMetadataOutputObjectsDelegate
{
    // 只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        // 0.清空图层
        clearConers()
        
        // 1.获取扫描到的数据
        // 注意: 要使用stringValue
        resultLabel.text = metadataObjects.last?.stringValue
        resultLabel.sizeToFit()
        
        // 2.获取扫描到的二维码的位置
        // 2.1转换坐标
        for object in metadataObjects
        {
            // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject
            {
                // 2.1.2将坐标转换界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                // 2.1.3绘制图形
                drawCorners(codeObject)
            }
        }
    }
    
    /**
     绘制图形
     
     :param: codeObject 保存了坐标的对象
     */
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject)
    {
        if codeObject.corners.isEmpty
        {
            return
        }
        
        // 1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        // 2.1移动到第一个点
        // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        // 2.2移动到其它的点
        while index < codeObject.corners.count
        {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        // 2.3关闭路径
        path.closePath()
        
        // 2.4绘制路径
        layer.path = path.CGPath
        
        // 3.将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
    }
    /**
     清空边线
     */
    private func clearConers(){
        // 1.判断drawLayer上是否有其它图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        
        // 2.移除所有子图层
        for subLayer in drawLayer.sublayers!
        {
            subLayer.removeFromSuperlayer()
        }
    }
}
