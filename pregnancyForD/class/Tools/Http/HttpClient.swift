//
//  HttpClient.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/24.
//  Copyright © 2017年 pg. All rights reserved.
//

import Foundation
import AFNetworking
import SVProgressHUD

class HttpClient {
    
    lazy var HCmanager : AFHTTPSessionManager = {
        let mg = AFHTTPSessionManager.init()
        mg.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json", "text/json", "text/javascript", "text/html", "text/plain") as? Set<String>
        mg.requestSerializer.timeoutInterval = 30
        mg.securityPolicy.allowInvalidCertificates = true
        mg.securityPolicy.validatesDomainName = false
        
        return mg
    }()
    
    
    // 设计成单例
    static let shareIntance : HttpClient = {
        let tools = HttpClient()
        return tools
    }()
    
    // 定义闭包别名
    typealias HttpRequestCompleted = (_ result : Any, _ ccb : CommonCallBack)->()
    
    func cancelAllRequest(){
        for t in HCmanager.tasks {
            t.cancel()
        }
    }
}

extension HttpClient {
    
    
    func POST(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted) {
        let parameDic = addCommonParameters(parameters)
        POST(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, parameters : NSDictionary?, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        GET(URLString, requestKey : nil, parameters : parameDic, callBack : callBack)
    }
    
    func GET(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
//        HCPrint(message: URLString)
//        HCPrint(message: parameters)
        
        HCmanager.get(URLString, parameters: parameters, progress: { (progress) in
            //
        }, success: { ( task : URLSessionDataTask, responseObject : Any?) in
            
            let ccb = CommonCallBack.init()
            let resDic = responseObject as! NSDictionary
            ccb.infoCode = resDic.value(forKey: "infoCode") as! NSInteger
            
            HCPrint(message: URLString)
            HCPrint(message: parameters)
            self.dealWithCode(code: ccb.infoCode)
            
            if ccb.infoCode != 200 {
                let m = resDic.value(forKey: "message") as? String
                ccb.message = m ?? ""
            }
            
            ccb.data = resDic.value(forKey: "data") ?? ""
            
            callBack(responseObject, ccb)
            
        }) { ( task : URLSessionDataTask?, error : Error) in
            
            HCPrint(message: URLString)
            HCPrint(message: parameters)
            HCPrint(message: error)
            
            let ccb = CommonCallBack.init()
            ccb.infoCode = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.message = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.message = HTTP_RESULT_NETWORK_ERROR
            }
            
            callBack("", ccb)
        }

        
    }
    
    
    
    func POST(_ URLString : String, requestKey : String?, parameters : NSDictionary, callBack : @escaping HttpRequestCompleted){
        
//        HCPrint(message: URLString)
//        HCPrint(message: parameters)

        HCmanager.post(URLString, parameters: parameters, progress: { (progress) in
            //
        }, success: { [unowned self](task : URLSessionDataTask, responseObject : Any) in
            
            let ccb = CommonCallBack.init()
            let resDic = responseObject as! NSDictionary
            ccb.infoCode = resDic.value(forKey: "infoCode") as! NSInteger
            
            HCPrint(message: URLString)
            HCPrint(message: parameters)
            
            self.dealWithCode(code: ccb.infoCode)
            
            ccb.data = resDic.value(forKey: "data")
        
            callBack(responseObject, ccb)
            
        }) { [unowned self](task : URLSessionDataTask?, error : Error) in
            
            HCPrint(message: URLString)
            HCPrint(message: parameters)
            HCPrint(message: error)
            
            let ccb = CommonCallBack.init()
            ccb.infoCode = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.message = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.message = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
        
    }
    
    func dealWithCode(code : NSInteger){
        HCPrint(message: code)

        if code == 401 {
            UserManager.shareIntance.logout()
        }
    
    }
    
    
    func addCommonParameters(_ param : NSDictionary? ) -> NSDictionary{
    
        var dic = NSMutableDictionary.init()
        if let param = param{
            dic = NSMutableDictionary.init(dictionary: param)
        }
        let infoDic = Bundle.main.infoDictionary
        
        dic["version"] = infoDic?["CFBundleShortVersionString"]
        dic["deviceType"] = "iOS"
        
        return dic as NSDictionary
    }
    
}

extension HttpClient {
    
    func uploadImage(_ URLString : String, parameters : NSDictionary?, imageArr : [UIImage], callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            for i in 0..<imageArr.count{
                let imageFile = imageArr[i]
                let fileN = String.init(format: "file%d", i)
                let imageN = String.init(format: "image%d.jpg", i)
                if imageFile.isKind(of: UIImage.classForCoder()){
                    formData.appendPart(withFileData: imageFile.jpegData(compressionQuality: 0.3)!, name: fileN, fileName: imageN, mimeType: "image/jpg")
                }
            }
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            ccb.infoCode = resDic.value(forKey: "infoCode") as! NSInteger
            
            self.dealWithCode(code: ccb.infoCode)
            
            ccb.data = resDic.value(forKey: "data")
            
            ccb.message = resDic.value(forKey: "message") as! String
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.infoCode = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.message = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.message = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }
    
    
    // 单张图片上传
    func uploadSingleImage(_ URLString : String, parameters : NSDictionary?, img : UIImage, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        
        HCPrint(message: URLString)
        HCPrint(message: parameDic)
        
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            let fileN = "file"
            let imageN = "img.jpg"
            formData.appendPart(withFileData: img.jpegData(compressionQuality: 0.1)!, name: fileN, fileName: imageN, mimeType: "image/jpg")
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            
            ccb.infoCode = resDic.value(forKey: "code") as! NSInteger
            
            ccb.message = resDic.value(forKey: "message") as! String
            
            ccb.data = resDic.value(forKey: "data")
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.infoCode = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.message = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.message = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }
    
    
    
    func uploadVoice(_ URLString : String, parameters : NSDictionary?, voiceFile : String, callBack : @escaping HttpRequestCompleted){
        let parameDic = addCommonParameters(parameters)
        HCmanager.post(URLString, parameters: parameDic, constructingBodyWith: { (formData) in
            
            let da = NSData.init(contentsOfFile: voiceFile)
            formData.appendPart(withFileData: da! as Data, name: "file01", fileName: "voice01.amr", mimeType: "audio/AMR")
            
        }, progress: { (progress) in
            //
        }, success: { (task, any) in
            
            let ccb = CommonCallBack.init()
            let resDic = any as! NSDictionary
            ccb.infoCode = resDic.value(forKey: "infoCode") as! NSInteger
            
            self.dealWithCode(code: ccb.infoCode)
            
            ccb.data = resDic.value(forKey: "data")
            
            ccb.message = resDic.value(forKey: "message") as! String
            
            callBack(any, ccb)
        }) { (task, errot) in
            let ccb = CommonCallBack.init()
            ccb.infoCode = 404
            
            if self.HCmanager.reachabilityManager.isReachable {
                ccb.message = HTTP_RESULT_SERVER_ERROR
            }else {
                ccb.message = HTTP_RESULT_NETWORK_ERROR
            }
            callBack("", ccb)
        }
    }

    func downloadVoice(url : URL, destiPath : String, callback : @escaping blankBlock){
        
        let request = URLRequest.init(url: url)
        let task = HCmanager.downloadTask(with: request, progress: { (progress) in
        }, destination: { (url, response) -> URL in
            return URL.init(fileURLWithPath: destiPath)
        }) { (response, url, error) in
            //  完成一次来一次
            callback()
        }
        
        task.resume()
    }
    
}

extension HttpClient {
    //版本检测
    func CheckVersion(){
        
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! NSString
        HCPrint(message: currentVersion)

        let localArray = currentVersion.components(separatedBy: ".")
        
        let urlS = "http://itunes.apple.com/lookup?id=" + kappID
        
        HCmanager.get(urlS, parameters: nil, progress: { (progress) in
            //
        }, success: { (task, any) in
//            HCPrint(message: any)
            
            let response = any as! NSDictionary
            let arr = response["results"] as! NSArray
            guard arr.count > 0 else{return}
            let dic = arr[0] as! NSDictionary
            let versionS = dic["version"] as! NSString
            let trackViewUrlS = dic["trackViewUrl"] as! String
            
            let versionArray = versionS.components(separatedBy: ".")
            
            for i in 0..<versionArray.count{
                if i > localArray.count - 1 {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在AppStore点击最下面的更新按钮，在更新界面刷新数据后，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                    return
                }
                
                let verInt = versionArray[i] as! NSString
                let locInt = localArray[i] as! NSString
                if verInt.intValue > locInt.intValue {
                    let alertController = UIAlertController(title: "新版上线",
                                                            message: "马上更新吗？如果更新失败，请在AppStore点击最下面的更新按钮，在更新界面刷新数据后，进行手动更新", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "马上更新", style: .default, handler: {(action)->() in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: trackViewUrlS)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL.init(string: trackViewUrlS)!)
                        }
                    })
                    
                    alertController.addAction(okAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }else if verInt.intValue < locInt.intValue {
                    return
                }
            }
            
            
        }) { (task, error) in
            HCPrint(message: "版本检测出错！")
        }
    }
}


extension HttpClient {
    
    func getWeixinOpenId(code : String){
        let appID = weixinAppid
        let secret = weixinSecret
        let urlS = String.init(format: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appID, secret, code)
        
        SVProgressHUD.show()
        DispatchQueue.global().async {[weak self]() in
            self?.HCmanager.get(urlS, parameters: nil, progress: { (progress) in
                //
            }, success: { (task, any) in
                let dic = any as! Dictionary<String, Any>
                
                let openid = dic["openid"] as! String
                
                HCPrint(message: openid)
                
                let token = UserManager.shareIntance.currentUser?.token!
                let infoDic = ["openId" : openid, "token" : token]
                
                self?.POST(UPDATE_DOCTOR_INFO, parameters: infoDic as NSDictionary) { (result, ccb) in
                    if ccb.infoCode == 200 {
                        HCShowInfo(info: "绑定成功")
                    }else{
                        HCShowError(info: "绑定失败")
                    }
                }
                
                
            }, failure: { (task, err) in
                HCPrint(message: err)
                HCShowError(info: "绑定失败！")
            })
        }
    }
    
}


