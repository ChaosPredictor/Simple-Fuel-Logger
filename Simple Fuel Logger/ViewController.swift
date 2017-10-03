//
//  ViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 27/09/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fuelField: UITextField!
    @IBOutlet weak var distnceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    @IBAction func button(_ sender: UIButton) {
        moveToNextResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        fuelField.becomeFirstResponder()
        
        
        fuelField.addButtonsOnKeyboard()
        distnceField.addButtonsOnKeyboard()

        //textField.upButtonAction()
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

    func resignFirstResponder() {
        print("dsf")
    }

}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addButtonsOnKeyboard()
            }
        }
    }
    
    func addButtonsOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let up: UIBarButtonItem = UIBarButtonItem(title: "△", style: .done, target: self, action: #selector(self.upButtonAction))
        let down: UIBarButtonItem = UIBarButtonItem(title: "▽", style: .done, target: self, action: #selector(self.downButtonAction))
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        
        let items = [flexSpace, up, down, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func upButtonAction() {
        print("up")
    }
    
    @objc func downButtonAction() {
        print("down")
    }

    @objc func doneButtonAction() {
        print("done")
    }
}
