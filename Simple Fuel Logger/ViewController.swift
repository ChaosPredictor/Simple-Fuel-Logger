//
//  ViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 27/09/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit
import UITextField_Navigation

class ViewController: UIViewController, NavigationFieldDelegate {

    @IBOutlet weak var fuelField: UITextField!
    @IBOutlet weak var distnceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    @IBAction func button(_ sender: UIButton) {
        moveToNextResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fuelField.becomeFirstResponder()
        fuelField.nextNavigationField = distnceField
        distnceField.nextNavigationField = priceField
        
    }

    func moveToNextResponder() {
        if fuelField.isFirstResponder {
            distnceField.becomeFirstResponder()
        } else {
            if distnceField.isFirstResponder {
                priceField.becomeFirstResponder()
            } else {
                fuelField.becomeFirstResponder()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}



