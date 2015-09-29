//
//  PreviewViewController.swift
//  SmashTag
//
//  Created by Xie kesong on 6/2/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    
    private var image: UIImage?{
        didSet{
            imageview.image = image
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageUrl: NSURL?{
        didSet{
            fetchImage()
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    
    
    private func fetchImage(){
        if let url = imageUrl{
            var iden = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(iden, 0)){ ()-> Void in
                let imageData = NSData(contentsOfURL: url)
                if imageData != nil{
                    dispatch_async(dispatch_get_main_queue()){
                        self.image = UIImage(data: imageData!)
                    }
                }
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //you can only add gesture to a UIView
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissPreview")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        scrollView.contentSize = imageview.bounds.size
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.backgroundColor = UIColor.blackColor()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissPreview(){
        if scrollView.zoomScale <= 1.0{
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            scrollView.zoomScale = 1.0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
