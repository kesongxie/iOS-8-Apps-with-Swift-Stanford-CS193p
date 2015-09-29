//
//  happinessViewController.swift
//  Happiness
//
//  Created by Xie kesong on 5/26/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class happinessViewController: UIViewController, FaceViewDataSource {
    //in the story board, all the things are linked up by the name
    //make sure change the corresponding identity to a specific subclass(happinessViewController, faceView,etc)
    
    //model is the data
    
    private struct constant{
        static let HappinessGestureScale: CGFloat = 4.0
    
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            //set the view's datasource to the controller itself, so that in the view 
            //it can call controller's implementation of the smilinessFaceView function
            faceView.dataSource = self
            
            //this is one of the way you can add gestureRecognizer, or you can
            //add it through the interface builder
            //since the pinch does not need to use model's data, and it can perfectly be performed in the view, when action funciton requires a parameter, add a colon after the function name
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    
    }
  
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y/constant.HappinessGestureScale)
            if happinessChange != 0{
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
            
        default:break
        }
    }
    
    var happiness : Int = 0{
        didSet{
            //property observer
            happiness = min(max(happiness,0),100)
            println("Hapiness is \(happiness)")
            updateUI()
        }
    }
    
    func smilinessFaceView(sender: FaceView) -> Double?{
        return Double(happiness-50)/50
    }
    
    
    func updateUI(){
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
    
}
