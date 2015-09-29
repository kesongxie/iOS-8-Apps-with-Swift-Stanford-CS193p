//
//  diagnosticHappinessController.swift
//  Psychologist
//
//  Created by Xie kesong on 5/28/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit


class DiagnosticHappinessController: happinessViewController, UIPopoverPresentationControllerDelegate{
    
    //use NSUserDefaults to store the data
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory:[Int]{
        get{
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
        set{
            defaults.setObject(newValue, forKey: History.DefaultsKey)
        }
    }
    
    override var happiness:Int{
        didSet{
            //it woudl concatonate the previous stored diagnosticHistory value
            diagnosticHistory += [happiness]
        }
    }
    
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultsKey = "DiagnosticHistoryForKey"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
            case History.SegueIdentifier:
                //imagine the segue as a line, the left hand side which trigger the segue is called sourceViewController, the right hand side which response to the segue is called destinationViewController,
                if let tvc = segue.destinationViewController as? TextViewController{
                    //if the right hand side destinationViewController is presented as a pop over controller, the property of the destination controller "popoverPresentationController" is not nil
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self //allow this DiagnosticHappinessController to controll the ways presentation works
                    }
                    
                    tvc.text = "\(diagnosticHistory)"
                }
            default:break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        //ask the delegate for a new presentation style
        //don't display Modal presentation
        return UIModalPresentationStyle.None
    }
    
    
    
    
}