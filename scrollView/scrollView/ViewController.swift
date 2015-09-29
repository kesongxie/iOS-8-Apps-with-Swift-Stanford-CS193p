//
//  ViewController.swift
//  scrollView
//
//  Created by Xie kesong on 5/30/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ImageViewController{
            if let iden = segue.identifier{
                switch iden{
                    case "Casinni": destination.imageURL = DemoURL.NASA.Cassini
                        destination.title = "Casinni"
                    case "Earth": destination.imageURL = DemoURL.NASA.earth
                        destination.title = "Earth"
                    case "Saturn": destination.imageURL = DemoURL.NASA.saturn
                        destination.title = "Saturn"
                default:break
                }
            }
        }
    }
  
}

