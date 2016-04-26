
# WeiDo


## About

  微博类整合客户端, 也是我第一个做的项目,所以杂七杂八的功能都有
  实现
  
- 新浪OAUTH授权、微博接口功能能做的都做了  

- tableview、collectionview的cell复杂定制,cell的高度缓存优化、图文混排使用、捕捉url/@
- 二维码扫描生成、CoreLocation定位及高德地图集成、本地推送、Avplayer、仿微信摇一摇、仿微信webview
- 接口使用:新浪、去哪儿网、高德地图、百度、百思不得姐、api store
- 实现社交分享,分享内容到QQ/QQ好友/微信好友/朋友圈
 
## Preview 

 ![](https://github.com/w11p3333/WeiDo/raw/master/Image/home.png) 
 ![](https://github.com/w11p3333/WeiDo/raw/master/Image/video.png) 
  ![](https://github.com/w11p3333/WeiDo/raw/master/Image/message.png) 
   ![](https://github.com/w11p3333/WeiDo/raw/master/Image/news.png) 
    ![](https://github.com/w11p3333/WeiDo/raw/master/Image/travel.png) 

## Usage
### Download

		git clone https://github.com/w11p3333/WeiDo.git
### install

		Product>CocoaPods>installpods
		
你必须登录一个新浪微博账号才可以使用主页和消息功能，你可以使用自己认证为开发者的新浪账号（需要在程序里修改app key and secret),或使用我的测试账号：llxtestuser@sohu.com  密码llxtestuser  
### CHANGELOG
#### v1.3(Apr 26, 2016)
- 重构应用，将所有网络处理加入到model中
- 替换自定义Navigation
- Lighter Controller

#### v1.2(Apr 15, 2016)
- 优化tableview cell高度
- 修改圆角渲染方式

#### v1.1(Mar 29, 2016)
- 替换MPMovieController为AVPlayer
- 修改图片浏览器
- 替换评论打开方式
- 添加分享模块

#### v1.0(Mar 19, 2016)
- 集成高德地图
- 集成天气

#### v0.9(Feb 3, 2016)
- 完成基本功能

## Discussing
AnyQuestion
#### Email:applecatkay@gmail.com
#### Blog:http://w11p3333.github.io/