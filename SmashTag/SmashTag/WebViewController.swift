//
//  WebViewController.swift
//  SmashTag
//
//  Created by Xie kesong on 6/6/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!{
        didSet{
            if let requestUrl = url{
                openUrl(requestUrl)
            }
        }
    }
    
    var url:String?
   
    func openUrl(url:String){
        let nsURL = NSURL(string: url)
        if let url = nsURL {
            let request = NSURLRequest(URL: url)
            webView?.loadRequest(request)
        }
    }
}
