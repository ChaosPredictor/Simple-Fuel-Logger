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

    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var today: CheckBox!
    @IBOutlet weak var fullTank: CheckBox!
    @IBOutlet weak var totalPriceLabel: UILabel!
    

    
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
        refuel.volume = Double(amountField.text!) ?? 0
        refuel.distance = Double(distanceField.text!) ?? -1
        refuel.price = Double(priceField.text!) ?? 0
        refuel.full = fullTank.isChecked
        
        if today.isChecked {
            refuel.date = Date()
        } else {
            refuel.date = datePicker.date
        }
    }
    
    func writeRefuelToField(refuel: Refuel) {
        amountField.text = String(describing: refuel.volume)
        distanceField.text = String(describing: refuel.distance)
        priceField.text = String(describing: refuel.price)
        datePicker.date = (refuel.date)!
        fullTank.isChecked = refuel.full
        fieldsDidChange(distanceField)
        
    }
    
    @IBAction func saveRefuel(_ sender: UIBarButtonItem) {
        if editMode {
            //EDIT
            print("edit mode save")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetch:NSFetchRequest = Refuel.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetch.sortDescriptors = [sortDescriptor]
            
            do {
                var refuels = try context.fetch(fetch)
                if let refuel = refuels[index] as Refuel?{
                    readRefuelFromField(refuel: refuel)
                    refuels[index] = refuel
                }
                do {
                    try context.save()
                    print("edited refuel saved")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            } catch {
                
            }
            _ = navigationController?.popViewController(animated: true)

        } else {
            //ADD
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

            cleanFields()
            
            self.performSegue(withIdentifier: "refuelList", sender: self)
            
        }
        
        
    }
    
    func cleanFields() {
        distanceField.text = ""
        priceField.text = ""
        amountField.text = ""
        fullTank.isChecked = true
        today.isChecked = true
        datePicker.isHidden = true
        todayLabel.isHidden = false
        totalPriceLabel.text = ""
        distanceField.becomeFirstResponder()
    }
    
    func getRefuel(index: Int) -> Refuel? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetch:NSFetchRequest = Refuel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        
        do {
            let refuels = try context.fetch(fetch)
            //let refuel = try context.fetch(Refuel.fetchRequest())[index] as Refuel
            let refuel = refuels[index]
            return refuel
            //writeRefuelToField(refuel: refuel)
        } catch {
            print("error in viewDidLoad")
        }
        return nil
    }
    
    func initEditRefuel(refuel: Refuel) {
        self.title = "Edit Refuel"
        todayLabel.isHidden = true
        today.isChecked = false
        writeRefuelToField(refuel: refuel)
        
    }
    
    func initAddRefuel() {
        self.title = "Add Refuel"

        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.isHidden = true
        
        amountField.placeholder = "Amount"
        distanceField.placeholder = "Distance"
        priceField.placeholder = "Price"
        totalPriceLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceField.becomeFirstResponder()
        distanceField.nextNavigationField = priceField
        priceField.nextNavigationField = amountField
        
        priceField.addTarget(self, action: #selector(fieldsDidChange(_:)), for: .editingChanged)
        amountField.addTarget(self, action: #selector(fieldsDidChange(_:)), for: .editingChanged)
        
        if index != -1 {
            
            editMode = true

            if let refuel = getRefuel(index: index) {
                initEditRefuel(refuel: refuel)
            }

        } else {
            
            editMode = false
            initAddRefuel()
            
        }

    }
    
    @objc func fieldsDidChange(_ textField: UITextField) {
        if let price = Double(priceField.text ?? "0"){
            if let volume = Double(amountField.text ?? "0"){
                let total = String((price * volume).rounded(toPlaces: 2))
                totalPriceLabel.text = total.padAsDoubleFromRight(totalWidth: 2, with: "0") + "₪"
            } else {
                totalPriceLabel.text = ""
            }
        } else {
            totalPriceLabel.text = ""
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



