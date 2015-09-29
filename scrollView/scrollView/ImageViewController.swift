//
//  ImageViewController.swift
//  scrollView
//
//  Created by Xie kesong on 5/30/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    //model
    var imageURL : NSURL?{
        didSet{
            image = nil
            //fetch the image only when the view is visiable in the window
            if view.window != nil{
                fetchImage()
            }
        }
    
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.bounds.size
            scrollView.delegate = self
            scrollView.maximumZoomScale = 1.0
            scrollView.minimumZoomScale = 0.3
            scrollView.backgroundColor = UIColor.blackColor()
        }
    }
    
    private var imageView = UIImageView()
    private var image:UIImage?{
        get{ return imageView.image}
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size //in case the image is set before the outlet is set
            spinner?.stopAnimating()
        }
    }
    
    
    //multi-threading handling
    private func fetchImage(){
        
        if let url = imageURL{
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                //perfrom those non-UI code outside of main thread
                let imageData = NSData(contentsOfURL: url) //// do something that might block or takes a while
                dispatch_async(dispatch_get_main_queue()){
                    //always switch to main thread when you want to update the UI
                    if url == self.imageURL{ //the first url is caprtured by the closure, and we need to check the current url is the same one as we 
                        //newly request, if it's not stop loading (in case the user click another image and the second image comes back before the previous image)
                        if imageData != nil {
                            self.image = UIImage(data: imageData!) //the image is wrapped in a closure, need to specify the self to capture
                        }else{
                            self.image = nil
                        }
                    }
                }
            }
         }
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    override func viewDidLoad() {
        //in viewDidLoad, all those outlets are set
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //screen on - off
        if image == nil{
            fetchImage()
        }
    }
    
    
    

}
