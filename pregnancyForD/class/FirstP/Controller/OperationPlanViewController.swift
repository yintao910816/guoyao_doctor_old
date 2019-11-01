//
//  OperationPlanViewController.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/11/30.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class OperationPlanViewController: UIViewController {
    
    var context : JSContext?

    var url : String?{
        didSet{
            HCPrint(message: url)
            if url != oldValue{
                if url!.contains("?"){
                    url = url! + "&token=" + (UserManager.shareIntance.currentUser?.token)!  + "&navHead=aly"
                    requestData()
                }else{
                    url = url! + "?token=" + (UserManager.shareIntance.currentUser?.token)! + "&navHead=aly"
                    requestData()
                }
            }
            HCPrint(message: url)
        }
    }
    var params : [String : Any]?
    
    
    lazy var webView : UIWebView = {
        let space = AppDelegate.shareIntance.space
        let w = UIWebView.init(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace))
        w.scrollView.bounces = false
        w.delegate = self
        return w
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = kDefaultThemeColor
        self.view.addSubview(webView)
        
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        url = "http://wx.ivfcn.com/operationPlan/view/SurgicalPlanning.html"
    }
    
    func requestData(){
        let request = URLRequest.init(url: URL.init(string: url!)!)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OperationPlanViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        
        let s = request.url?.absoluteString
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
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS调用SVProgresssHUD
        let showSVProgressHUD: @convention(block) () ->() = {
            DispatchQueue.main.async {[weak self]in
                SVProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    SVProgressHUD.dismiss()
                })
            }
        }
        context?.setObject(unsafeBitCast(showSVProgressHUD, to: AnyObject.self), forKeyedSubscript: "loading" as NSCopying & NSObjectProtocol)
        
        context?.exceptionHandler = {(context, value)in
            HCPrint(message: value)
        }
    
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        HCPrint(message: error.localizedDescription)
    }
    
}

