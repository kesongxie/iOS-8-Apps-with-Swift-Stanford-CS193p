//
//  TextViewController.swift
//  Psychologist
//
//  Created by Xie kesong on 5/28/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = text // no need for optional chaining
        }
    }
  
   
    //model of textView controller
    var text : String = ""{
        didSet{
            textView?.text = text //in case the outlet is no  yet set when preparaing
        }
    }
    
    
    
    override var preferredContentSize: CGSize{
        get{
            if textView != nil && presentingViewController != nil{
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
        set{
            super.preferredContentSize = newValue
        }
    }
    
    
}
