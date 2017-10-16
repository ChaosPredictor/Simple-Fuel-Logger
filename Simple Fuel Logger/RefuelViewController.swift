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
    
    @IBAction func exportButton(_ sender: UIBarButtonItem) {
        // Set the file path
        //let path = "myfile.txt"
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let path = documentsPath.appendingPathComponent("myfile.txt")
        
        
        // Set the contents
        let contents = "Here are my file's contents"
        
        do {
            // Write contents to file
            try contents.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
            print("saed to \(String(describing: path))")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
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
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetch:NSFetchRequest = Refuel.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            fetch.sortDescriptors = [sortDescriptor]
            
            do {
                var refuels = try context.fetch(fetch)
                if let refuel = refuels[index] as Refuel?{
                    readRefuelFromField(refuel: refuel)
                    print("value: \(refuel.volume)")
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
        
        fuelField.placeholder = "Volume"
        distanceField.placeholder = "Distance"
        priceField.placeholder = "Price"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fuelField.becomeFirstResponder()
        fuelField.nextNavigationField = distanceField
        distanceField.nextNavigationField = priceField
        
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



