//
//  MainTabBarController.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override var childForStatusBarStyle: UIViewController?{
        get {
            return self.selectedViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(childControllerName: "FirstPageViewController", title: "首页", normalImage: "Home")
        addChildViewController(childControllerName: "HomeTableViewController", title: "咨询消息", normalImage: "Consult")
        addChildViewController(childControllerName: "GroupViewController", title: "患者管理", normalImage: "Group")
        addChildViewController(childControllerName: "UserTableViewController", title: "个人", normalImage: "User")
    
        //文字颜色
        self.tabBar.tintColor = kDefaultThemeColor
        self.tabBar.isTranslucent = false
        
        // check is member?
//        HttpRequestManager.shareIntance.HC_isMember(token: (UserManager.shareIntance.currentUser?.token)!) { (success, msg) in
//            UserManager.shareIntance.currentUser?.isMemb = success
//        }
        
    }
    
    private func addChildViewController(childControllerName : String, title : String, normalImage : String) {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            return
        }
        
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        // 设置TabBar和Nav的标题
        childController.title = title
//        childController.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        childController.tabBarItem.selectedImage = UIImage(named: normalImage + "_HL")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        childController.tabBarItem.image = UIImage(named: normalImage)
        childController.tabBarItem.selectedImage = UIImage(named: normalImage + "_HL")
        
        // 包装导航控制器
        let nav = BaseNavigationController(rootViewController: childController)
        self.addChild(nav)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}




