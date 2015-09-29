//
//  ViewController.swift
//  Caculator
//
//  Created by Xie kesong on 4/20/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class CaculatorViewController: UIViewController {
    //when copy elements in the storyboard, we will copy the properties or actions as well
    
   @IBOutlet weak var display: UILabel! // pointer, optional, automatic unwrap, then we need a exclamation mark in the decolaration, good for some kind of properties getting set ver early, and would stay forever, implicitly unwrap
    var userInTheMiddleOfTying = false
    var constantExpresson = false
    var brain = CalculatorBrain()
    @IBAction func appendDigit(sender: UIButton) {
         //hold down the option keep under the digit or UIButton to see its info
        if let digit = sender.currentTitle{
            if userInTheMiddleOfTying {
                if display.text?.rangeOfString(".") == nil || digit != "." {
                    display.text = display.text! + digit
                }
            }else{
                userInTheMiddleOfTying = true
                display.text = digit
            }
        }
    }
    
    @IBAction func undo(sender: UIButton) {
        if userInTheMiddleOfTying{
            //remove digit
            var input = display.text!
            input = dropLast(input)
            if countElements(input) == 0{
                display.text = "0"
                userInTheMiddleOfTying = false
            }else{
                display.text = input
            }
        }else{
            //undo the previous evaluation
            brain.popOp()
            if let result = brain.evaluate(){
                 display.text  =  "\(result)"
            }
        }
    }
    
    
    
    @IBAction func setVariable(sender: UIButton) {
        brain.varibleValues["M"] = displayValue
        userInTheMiddleOfTying = false
        if let result = brain.evaluate(){
            display.text  =  "\(brain)=\(result)"
        }
    }
    
    @IBAction func appendVariable(sender: UIButton) {
        if let variable = sender.currentTitle{
            if let result = brain.pushOperand(variable){
                display.text = "\(result)" //this would trigger the setter for the computed property
            }
        }
    }
    
    @IBAction func appendConst(sender: UIButton) {
        constantExpresson = true
        if let const = sender.currentTitle{
            if userInTheMiddleOfTying {
                display.text = display.text! + const
            }else{
                userInTheMiddleOfTying = true
                display.text = const
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userInTheMiddleOfTying {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performAction(operation){
                display.text = "\(brain)=\(result)" //this would trigger the setter for the computed property
            }else{
                if let error = brain.getErorrMessage(){
                    display.text = "\(error)"
                }
            }
        }
        
    }
    
    @IBAction func clearInput(sender: UIButton) {
        brain.clearInput()
        display.text = "0"
        userInTheMiddleOfTying = false
        brain.varibleValues.removeAll(keepCapacity: false)
    }
    
    
    @IBAction func enter() {
        userInTheMiddleOfTying = false
        if constantExpresson{
            if let const = display.text {
                if let result =  brain.pushConstant(const){
                    displayValue = result
                }
            }
            constantExpresson = false
        }else{
            if let digit = displayValue{
                if let result = brain.pushOperand(digit){
                    displayValue = result //result can not be nil
                }else{
                    display.text = "error"
                }
            }
        }
    }
    
    var displayValue:Double?{
        get{
            //numberFromString may fail, and it returns an optional, we need to unwrap it
            if let num = NSNumberFormatter().numberFromString(display.text!) {
                return num.doubleValue
            }
            return nil
        }
        set{
            //The setter is to modify the non-computed_properties
            //if somewhere has displayValue = 3, this would assign 3 to the newValue and then set the display.text to 3
            if newValue != nil{
                display.text = "\(newValue!)" //the newValue is a magic varible that would contain the new value
            }else{
                display.text = "0"
                userInTheMiddleOfTying = false
            }
        }
    }
    
    // Your view controller overrides this method when it needs to pass relevant data to the new view controller(the controller which is about to be displayed).
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nav = destination as? UINavigationController{
            destination = nav.visibleViewController
        }
        if let gvc = destination as? GraphViewController{
            if let identifier = segue.identifier{
                
                switch identifier{
                    case "graph":
                        gvc.brain = brain
                        var expression = split(brain.description){$0 == ","}
                        gvc.title = expression.last
                    default:break
                }
            }
        }
    }
    
    

    
}

