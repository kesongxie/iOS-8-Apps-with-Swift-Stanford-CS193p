//
//  graphInfoViewController.swift
//  Caculator
//
//  Created by Xie kesong on 5/29/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class GraphInfoViewController: UIViewController {
    
    @IBOutlet weak var localMax: UILabel!{
        didSet{
            localMax.text = "Maximum "+localMaxValue
        }
    }
    
    @IBOutlet weak var localMin: UILabel!{
        didSet{
            localMin.text = "Mnimum "+localMinValue
        }
    }

    override func viewDidLoad() {
        //viewDidLoad is a great place for updating the UI, by the time this method is called, all those outlets are set
        
        //! be careful, the geomethry such as bounds all related stuffs has not been set yet
    }
    

    //model
    var localMaxValue:String = ""
    var localMinValue:String = ""

}
