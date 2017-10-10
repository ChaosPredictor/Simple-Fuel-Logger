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
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var today: CheckBox!
    
    @IBAction func todayCheckBox(_ sender: CheckBox) {
        if sender.isChecked {
            datePicker.isHidden = false
            todayLabel.isHidden = true
        } else {
            datePicker.isHidden = true
            todayLabel.isHidden = false
        }
    }
    
    @IBAction func saveRefuel(_ sender: UIBarButtonItem) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let refuel = Refuel(context: context)
        refuel.volume = Double(fuelField.text!) ?? 0
        refuel.distance = Double(distanceField.text!) ?? 0
        refuel.price = Double(priceField.text!) ?? 0
        
        if today.isChecked {
            refuel.date = Date()
        } else {
            refuel.date = datePicker.date
        }
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
        
        do {
            try context.save()
            print("refuel saved")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fuelField.becomeFirstResponder()
        fuelField.nextNavigationField = distanceField
        distanceField.nextNavigationField = priceField
        
        fuelField.placeholder = "Volume"
        distanceField.placeholder = "Distance"
        priceField.placeholder = "Price"

        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}



