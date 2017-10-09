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
    
    
    @IBAction func saveRefuel(_ sender: UIBarButtonItem) {
        print("saverefuel")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let refuel = Refuel(context: context)
        refuel.volume = Double(fuelField.text!) ?? 0
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            print("in do")
            let refuels = try context.fetch(Refuel.fetchRequest())
            if let volume = (refuels[0] as AnyObject).volume {
                print(volume)
            }
        } catch {
            print("Fetching Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fuelField.becomeFirstResponder()
        fuelField.nextNavigationField = distnceField
        distnceField.nextNavigationField = priceField
        
        getData()
        
    }
/*
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
  */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}



