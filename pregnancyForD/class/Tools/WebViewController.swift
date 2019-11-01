//
//  WebViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class WebViewController: UIViewController {
    var url : String?{
        didSet{
            HCPrint(message: url)
            if url != oldValue{
                if url!.contains("?"){
                    if url!.last == "?"{
                        url = url! + "token=" + (UserManager.shareIntance.currentUser?.token)!  + "&navHead=aly"
                        requestData()
                    }else{
                        url = url! + "&token=" + (UserManager.shareIntance.currentUser?.token)!  + "&navHead=aly"
                        requestData()
                    }
                }else{
                    url = url! + "?token=" + (UserManager.shareIntance.currentUser?.token)! + "&navHead=aly"
                    requestData()
                }
            }
            HCPrint(message: url)
        }
    }
    
    
    var params : [String : Any]?
    
    var context : JSContext?
    
    
    lazy var webView : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let w = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        w.scrollView.bounces = false
        w.delegate = self
        self.view.addSubview(w)
        return w
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        self.view.backgroundColor = kDefaultThemeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let leftItem = UIBarButtonItem(image: UIImage(named: "zuo-"), style: .plain, target: self, action: #selector(WebViewController.popViewController))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func requestData(){
        SVProgressHUD.show()
        let request = URLRequest.init(url: URL.init(string: url!)!)
        webView.loadRequest(request)
    }

    @objc func popViewController(){
        if webView.canGoBack{
            webView.goBack()
        }else{
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setTitle(){
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            self.navigationItem.title = title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WebViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        let s = request.url?.absoluteString
        HCPrint(message: "h5 -- 地址：\(s)")

        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
            return false
        }else if (s?.contains("http"))!{
            return true
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        HCPrint(message: "didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        HCPrint(message: "didFinishLoad")
        SVProgressHUD.dismiss()
        
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS调用了无参数swift方法
        let openWeixinBindView: @convention(block) () ->() = {[weak self]in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(CountViewController(), animated: true)
            }
        }
        context?.setObject(unsafeBitCast(openWeixinBindView, to: AnyObject.self), forKeyedSubscript: "openWeixinBindView" as NSCopying & NSObjectProtocol)
        
        
        context?.exceptionHandler = {(context, value)in
            HCPrint(message: value)
        }
        
        setTitle()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        HCPrint(message: error.localizedDescription)
        SVProgressHUD.dismiss()
    }
    
}

