//
//  ViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 27/09/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit
import UITextField_Navigation
import CoreData

class RefuelViewController: UIViewController, NavigationFieldDelegate {

    @IBOutlet weak var fuelField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var today: CheckBox!
    @IBOutlet weak var fullTank: CheckBox!
    
    var refuel: Refuel?
    var index = -1
    var editMode = false
    
    @IBAction func todayCheckBox(_ sender: CheckBox) {
        if sender.isChecked {
            datePicker.isHidden = false
            todayLabel.isHidden = true
        } else {
            datePicker.isHidden = true
            todayLabel.isHidden = false
        }
    }
    
    func readRefuelFromField(refuel: Refuel) {
        refuel.volume = Double(fuelField.text!) ?? 0
        refuel.distance = Double(distanceField.text!) ?? 0
        refuel.price = Double(priceField.text!) ?? 0
        refuel.full = fullTank.isChecked
        
        if today.isChecked {
            refuel.date = Date()
        } else {
            refuel.date = datePicker.date
        }
    }
    
    func writeRefuelToField(refuel: Refuel) {
        fuelField.text = String(describing: refuel.volume)
        distanceField.text = String(describing: refuel.distance)
        priceField.text = String(describing: refuel.price)
        datePicker.date = (refuel.date)!
        fullTank.isChecked = refuel.full
    }
    
    @IBAction func saveRefuel(_ sender: UIBarButtonItem) {
        if editMode {
            print("edit mode save")
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let refuel = Refuel(context: context)

            readRefuelFromField(refuel: refuel)
            
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

    }
    
    override func viewDidLoad() {
        print("Loaded")
        super.viewDidLoad()

        fuelField.becomeFirstResponder()
        fuelField.nextNavigationField = distanceField
        distanceField.nextNavigationField = priceField
        
        if index != -1 {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
            let fetch:NSFetchRequest = Refuel.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetch.sortDescriptors = [sortDescriptor]
                
            do {
                let refuels = try context.fetch(fetch)
                //let refuel = try context.fetch(Refuel.fetchRequest())[index] as Refuel
                let refuel = refuels[index]
                writeRefuelToField(refuel: refuel)
            } catch {
                print("error in viewDidLoad")
            }
            
            todayLabel.isHidden = true
            today.isChecked = false
            self.title = "Edit Refuel"
            editMode = true
        } else {
            fuelField.placeholder = "Volume"
            distanceField.placeholder = "Distance"
            priceField.placeholder = "Price"
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.isHidden = true
            editMode = false
        }



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Appear")
        print("Refuel is \(String(describing: refuel))")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //refuel = Refuel()
        
    }


}



