//
//  UserManager.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/25.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import WebKit

class UserManager: NSObject {
    
    var currentUser : UserModel? 

    var phone : String?
    
    // 设计成单例
    static let shareIntance : UserManager = {
        let tools = UserManager()
        return tools
    }()

    
    func loginBySms(_ number : String, code : String, callback : @escaping (_ success : Bool, _ message : String)->()){
        HttpRequestManager.shareIntance.loginBySms(number, code: code) { [unowned self](success, user, message) in
            if success {
                self.currentUser = user
                //业务逻辑：有了个人信息才能接受推送
                UMessage.registerForRemoteNotifications()
                callback(true, "登录成功")
            }else{
                callback(false, message)
            }
        }
    }
    
    func logout(){
        HttpClient.shareIntance.cancelAllRequest()
        
        //清理缓存
        if #available(iOS 9.0, *) {
            let types = WKWebsiteDataStore.allWebsiteDataTypes()
            let dateForm = Date.init(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateForm, completionHandler: {
                HCPrint(message: "clear cache")
            })
        }
        
        UMessage.unregisterForRemoteNotifications()
        UserDefaults.standard.removeObject(forKey: kCurrentUser)
        currentUser = nil
        HCShowInfo(info: "注销成功！")
        UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
    }

}
