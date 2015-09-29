//
//  ViewController.swift
//  Psychologist
//
//  Created by Xie kesong on 5/28/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {
   
    //show the segue in normal target action
    @IBAction func nothing(sender: UIButton) {
        //the second parameter is whatever trigger the segue, in this case, the nothing button, and 
        //this would be sent to the prapareForSegue sender arguement
        performSegueWithIdentifier("nothing", sender: nil)
        //even though we are doing the segue in code, we still need to prepare segue
    }
    
    //be careful that the outlet of the viewcontroller has not yet been set when the preparation done, need to hold on and after the outlet has been set, then modify it or do it in the property observer(didSet), optional chaining
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       var  destination = segue.destinationViewController as? UIViewController
        if let navCon =  destination as? UINavigationController{
            destination = navCon.visibleViewController
        }
        
        if let hvc = destination as? happinessViewController{
            if let identifier = segue.identifier{
                switch identifier{
                    case "Sad": hvc.happiness = 0
                    case "Happy":hvc.happiness = 100
                    case "nothing" :hvc.happiness = 25 //still need to prepare the segue for the normal action
                    default:hvc.happiness = 50
                }
            }
        }
    }
    

}

