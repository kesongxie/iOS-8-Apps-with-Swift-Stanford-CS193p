//
//  GraphView.swift
//  Caculator
//
//  Created by Xie kesong on 5/28/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

protocol GraphViewDataSource{
    func getFunctionValue(x: Double) -> Double?
    func resetMaxAndMin()
}


@IBDesignable
class GraphView:  UIView {
    private var drawAxes = AxesDrawer()
    private var defaults = NSUserDefaults()
    private var isLoadedPreviousScale = false
    private var isLoadedPreviousDeltaX = false
    private var isLoadedPreviousDeltaY = false
    
    private struct keyConstant{
        static let preferrenceForKey = "preferrenceForKey"
        static let keyForScaleInUIPreferred = "preferredKeyForScale"
        static let keyForDeltaXInUIPreferred = "preferredKeyForDeltaX"
        static let keyForDeltaYInUIPreferred = "preferredKeyForDeltaY"
    }
    
    //create a property list
    private var UIPreferred:[String:String]{
        get{
            return defaults.dictionaryForKey(keyConstant.preferrenceForKey) as? [String:String] ?? [String:String]()
        }
        set{
            defaults.setObject(newValue, forKey: keyConstant.preferrenceForKey)
        }
    }
    
    
    private var AxesOrigin:CGPoint{
        get{
            return CGPoint(x:center.x + deltaX , y:center.y + deltaY )
        }
    }
    
    
    var deltaX:CGFloat = 0{
        didSet{
            if isLoadedPreviousDeltaX{
                UIPreferred[keyConstant.keyForDeltaXInUIPreferred] = "\(deltaX)"
            }else{
                if let previousDeltaX = UIPreferred[keyConstant.keyForDeltaXInUIPreferred]{
                    if let convert = NSNumberFormatter().numberFromString(previousDeltaX){
                        deltaX = CGFloat(convert.doubleValue)
                    }
                }
                isLoadedPreviousDeltaX = true
            }
            setNeedsDisplay()
        }
    
    }
    

    var deltaY:CGFloat = 0{
        didSet{
            if isLoadedPreviousDeltaY{
                UIPreferred[keyConstant.keyForDeltaYInUIPreferred] = "\(deltaY)"
            }else{
                if let previousDeltaY = UIPreferred[keyConstant.keyForDeltaYInUIPreferred]{
                    if let convert = NSNumberFormatter().numberFromString(previousDeltaY){
                        deltaY = CGFloat(convert.doubleValue)
                    }
                }
                isLoadedPreviousDeltaY = true
            }
            setNeedsDisplay()
        }
        
    }
    
    private var pointsPerUnit:CGFloat{ return 50 * scale }
    
    
    @IBInspectable
    var scale:CGFloat = 1.0{
        didSet{
            if isLoadedPreviousScale{
                UIPreferred[keyConstant.keyForScaleInUIPreferred] = "\(scale)"
            }else{
                if let previousScale = UIPreferred[keyConstant.keyForScaleInUIPreferred]{
                    if let convert  = NSNumberFormatter().numberFromString(previousScale){
                        scale = CGFloat(convert.doubleValue)
                    }
                }
                isLoadedPreviousScale = true
            }
            setNeedsDisplay()
        }
    }
    
    
    var dataSource: GraphViewDataSource?
   
    override func drawRect(rect: CGRect){
        drawAxes.drawAxesInRect(rect, origin: AxesOrigin , pointsPerUnit: pointsPerUnit);
        let path = UIBezierPath()
        var isPreviousPointNotExist = false
        dataSource?.resetMaxAndMin()
        for x in 0...Int(bounds.width){
            let xValue = (Double(x) - Double(AxesOrigin.x)) / Double(pointsPerUnit)
            
            var yValue:Double?
            if let y = dataSource?.getFunctionValue(Double(xValue)){
                 yValue = Double(AxesOrigin.y) - y * Double(pointsPerUnit)
            }
            
            if x == 0 || isPreviousPointNotExist{
                if let y = yValue{
                    path.moveToPoint(CGPoint(x: Double(x),y: Double(y)))
                    isPreviousPointNotExist = false
                }else{
                    isPreviousPointNotExist = true
                }
            }else{
                if let y = yValue{
                    path.addLineToPoint(CGPoint(x: Double(x), y: Double(y)))
                    isPreviousPointNotExist = false
                }else{
                    isPreviousPointNotExist = true
                }
            }
        }
        UIColor.redColor().setStroke()
        path.lineWidth = 3.0
        path.stroke()
    }
    
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func dragAround(gesture: UIPanGestureRecognizer){
        if gesture.state == .Changed{
            let translation = gesture.translationInView(self)
            let changeY = translation.y
            let changeX = translation.x
            if changeX != 0 || changeY != 0 {
                deltaX += changeX
                deltaY += changeY
                setNeedsDisplay()
                gesture.setTranslation(CGPointZero, inView: self)
            }
            
        }
    }
    
    func tapTo(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended{
            deltaX = -(gesture.locationInView(self).x - AxesOrigin.x)
            deltaY = -(gesture.locationInView(self).y - AxesOrigin.y)
            setNeedsDisplay()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
