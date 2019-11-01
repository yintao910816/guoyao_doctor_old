//
//  BaseNavigationController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/6.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController{
    
    override var childForStatusBarStyle: UIViewController?{
        get {
            return self.topViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = kDefaultThemeColor
        self.navigationBar.isTranslucent = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //设置被push界面的返回按钮样式：隐藏文字
        if children.count > 0 {
            let vc = children[0]
            vc.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        }
        super.pushViewController(viewController, animated: true)
    }
}


