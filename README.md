# WeiboHomePageDemo
问题来自于segmentfault问题[请教一下新浪微博的个人主页实现思路](http://segmentfault.com/q/1010000003056410)

本demo只是将个人的理解进行了实践：
>* 导航栏渐变的效果，可以参考glowing团队的博文：[动态修改UINavigationBar的背景色](http://tech.glowing.com/cn/change-uinavigationbar-backgroundcolor-dynamically/)；
>* 三个按钮放在section headerView上面，点击按钮切换响应的datasource；
>* 背景图片放在table headerView上面，背景拉伸，在scrollViewDidScroll方法里面进行相应操作；

