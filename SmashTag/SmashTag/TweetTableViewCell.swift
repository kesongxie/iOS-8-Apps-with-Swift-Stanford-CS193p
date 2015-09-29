//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Xie kesong on 5/31/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    //model
    var tweet: Tweet?{
        didSet{
            updateUI()
        }
    }
    
    var cache = NSCache()
    
    private struct preferredUIColor{
        static let ScreenNameColor = UIColor(red: 0.84, green: 0.04, blue: 0.36, alpha: 1.0)
        static let MentionedColor = UIColor(red: 0.04, green: 0.65, blue: 0.84, alpha: 1.0)
        static let tweetTextColor = UIColor(red: 0.49, green: 0.48, blue: 0.48, alpha: 1.0)
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!{
        didSet{
            tweetScreenNameLabel.textColor = preferredUIColor.ScreenNameColor
        }
    }
    @IBOutlet weak var tweetTextLabel: UILabel!{
        didSet{
            tweetTextLabel.textColor = preferredUIColor.tweetTextColor
        }
    }
    
    
    
    
    
    func updateUI(){
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet{
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media{
                    tweetTextLabel.text! += " "
                }
            }
            
            if tweetTextLabel != nil{
                var newAttributedString = NSMutableAttributedString(attributedString: tweetTextLabel.attributedText)
                
                //Style the hash tags
                for tag in tweet.hashtags{
                    newAttributedString.addAttribute(NSForegroundColorAttributeName, value:preferredUIColor.MentionedColor, range: tag.nsrange)
                }

                //Style the urls
                for url in tweet.urls{
                    newAttributedString.addAttribute(NSForegroundColorAttributeName, value:preferredUIColor.MentionedColor, range: url.nsrange)
                }
                
                //Style the user mentions
                for user in tweet.userMentions{
                    newAttributedString.addAttribute(NSForegroundColorAttributeName,value:preferredUIColor.MentionedColor, range: user.nsrange)
                }
                tweetTextLabel.attributedText = newAttributedString
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            if let profileImageURL = tweet.user.profileImageURL{
               let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL) //this may block the main queue, takes for a while, so we handle thia outside of the main queue
                    dispatch_async(dispatch_get_main_queue()){
                        if imageData != nil{
                            self.tweetProfileImageView?.image = UIImage(data: imageData!) //block the main thread
                        }
                    }
                }
            }
            
        }
        
    }
}
