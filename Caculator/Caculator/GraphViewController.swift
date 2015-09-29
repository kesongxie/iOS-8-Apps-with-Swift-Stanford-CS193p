//
//  GraphViewController.swift
//  Caculator
//
//  Created by Xie kesong on 5/28/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class GraphViewController: CaculatorViewController, GraphViewDataSource, UIPopoverPresentationControllerDelegate {
    
    var localMax:Double?
    var localMin:Double?
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            graphView.dataSource = self
        graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "dragAround:"))
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: "tapTo:")
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let gvc = segue.destinationViewController as? GraphInfoViewController {
            if let iden = segue.identifier{
                switch iden{
                    case "graph info":
                        if let pvc = gvc.popoverPresentationController{
                            pvc.delegate = self
                        }
                        
                        if localMax != nil{
                            gvc.localMaxValue = "\(localMax!)"
                        }
                        if localMin != nil{
                            gvc.localMinValue = "\(localMin!)"
                        }
                    default:break
                }
            }
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    
    func resetMaxAndMin(){
        localMax = nil
        localMin = nil
    }

    func getFunctionValue(x: Double) -> Double?{
        brain.varibleValues["M"] = x
        var yValue:Double?
        if let result = brain.evaluate(){
            localMax = ( localMax == nil ? result : max(localMax!,result) )
            localMin = ( localMin == nil ? result : min(localMin!,result) )
            yValue = result
        }
        return yValue
    }
}
