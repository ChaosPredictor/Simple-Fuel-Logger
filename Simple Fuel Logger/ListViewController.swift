//
//  ListViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 06/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit
import CoreData
import os.log

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("list view controller loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exportButton(_ sender: UIBarButtonItem) {
        exportToFile()
    }
    
    func exportToFile() {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let path = documentsPath.appendingPathComponent("myfile.txt")
        
        // Set the contents
        let contents = refuelsToString()
        
        do {
            // Write contents to file
            try contents.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
            print("Saved to \(String(describing: path))")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func refuelsToString() -> String {
        let refuels = getRefuelsFromCoreData()
        var string = "date,distance,volume,full,price\n"

        for refuel in refuels {
            string.append("\(refuel.date!),\(refuel.distance),\(refuel.volume),\(refuel.full),\(refuel.price)\n")
        }
        return string
        //print(string)
    }
    
    func getRefuelsFromCoreData() -> [Refuel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch:NSFetchRequest = Refuel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        
        do {
            let refuels = try context.fetch(fetch)
            return refuels
        } catch {
            print("Fetching Failed")
            return []
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //@IBAction func saveRefuel(_ sender: UIBarButtonItem) {
    //}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let refuels = try context.fetch(Refuel.fetchRequest())
            return refuels.count
        } catch {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefuelTableViewCell", for: indexPath) as! RefuelTableViewCell

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch:NSFetchRequest = Refuel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        
        do {
            let refuels = try context.fetch(fetch)
            //let refuels = try context.fetch(Refuel.fetchRequest())
            
            let refuel = refuels[indexPath.row]
            cell.volumeLabel?.text = "\(refuel.volume)ℓ"
            cell.distanceLabel?.text = "\(refuel.distance)km"

            if let date = refuel.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY/MM/dd"
                cell.dateLabel?.text = dateFormatter.string(from: date)
            }

            if refuel.full {
                cell.tankImageView.image = UIImage(imageLiteralResourceName: "fulltank_step2")
            } else {
                cell.tankImageView.image = UIImage(imageLiteralResourceName: "emptytank_step1")
            }

        } catch {
            print("Fetching Failed")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            do {
                var refuels = try context.fetch(Refuel.fetchRequest())
                context.delete(refuels[indexPath.row] as! Refuel)
                do {
                    try context.save()
                    print("Remove - refuel saved")
                } catch {
                    let nserror = error as NSError
                    print("Remove - refuel not saved")
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                print("Remove - refuel done")

            } catch {
                print("Remove - refuel not done")
            }
            tableView.reloadData()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        super.prepare(for: segue, sender: sender)

        //do {
            //let refuels = try context.fetch(Refuel.fetchRequest())
            
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new meal.", log: .default, type: .debug)
            case "EditRefuel":
                guard let refuelDetailViewController = segue.destination as? RefuelViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedRefuelCell = sender as? RefuelTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedRefuelCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                //let selectedRefuel = refuels[indexPath.row]
                //print("Sending index:\(indexPath.row) \(String(describing: selectedRefuel))")
                //refuelDetailViewController.refuel = selectedRefuel as? Refuel
                refuelDetailViewController.index = indexPath.row
            
            default:
                print("default")
        }
        //} catch {
        //    print("error")
        //}
    }
    
}
