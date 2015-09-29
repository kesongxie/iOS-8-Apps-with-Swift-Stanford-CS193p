//
//  DetailTableViewCell.swift
//  SmashTag
//
//  Created by Xie kesong on 6/1/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    var tweet: Tweet?{
        didSet{
            updateUI()
        }
    }
    var rowInSection = 0
    var imageUrl:NSURL?
    
    @IBOutlet weak var imageContainer: UIImageView!
    func updateUI(){
        var mediaItem = tweet?.media[rowInSection]
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)){ ()->Void in
            if let imageURL = mediaItem?.url{
                let imageData = NSData(contentsOfURL: imageURL)
                dispatch_async(dispatch_get_main_queue()){
                    if imageData != nil{
                        self.imageUrl = imageURL
                        self.imageContainer.image = UIImage(data: imageData!)
                    }
                }
            }
        }
    }
}
