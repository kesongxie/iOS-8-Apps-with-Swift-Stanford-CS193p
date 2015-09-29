//
//  URLTableViewCell.swift
//  SmashTag
//
//  Created by Xie kesong on 6/2/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class URLTableViewCell: UITableViewCell {
    var tweet: Tweet?{
        didSet{
            if let section = sectionInTable{
                if let row = rowInSection{
                    switch section{
                    case 3:
                        if tweet?.urls.count > 0  {
                            keyWord = tweet!.urls[row].keyword
                        }
                    default:break
                    }
                }
            }
        }
    }
    var keyWord:String = ""{
        didSet{
            context?.text = keyWord
        }
    }
    
    var sectionInTable: Int?
    var rowInSection: Int?
    
    @IBOutlet weak var context: UILabel!{
        didSet{
            context.text = keyWord
            context.textColor = UIColor(red: 0.04, green: 0.65, blue: 0.84, alpha: 1.0)
         //   var tapGesture = UITapGestureRecognizer(target: self, action: "openLink:")
          //  self.addGestureRecognizer(tapGesture)
            
            
        }
        
    }
    
     func openLink(gesture:UITapGestureRecognizer){
        if let nsurl = NSURL(string: keyWord){
            if UIApplication.sharedApplication().canOpenURL(nsurl){
                UIApplication.sharedApplication().openURL(nsurl)
            }
        }
    }
}
