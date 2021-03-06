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
    
    @IBAction func importButton(_ sender: UIBarButtonItem) {
        importFromFile()
    }
    
    func importFromFile() {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let path = documentsPath.appendingPathComponent("myfile.txt")
        var csvRows:[[String]]
        do {
            let string = try String(contentsOf: path!, encoding: String.Encoding.utf8)
            csvRows = csv(data: string)
            deleteAllCoreData()
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            for index in 1...csvRows.count-2 {
                let refuel = Refuel(context: context)

                let dateTime = csvRows[index][0].characters.split{$0 == " "}.map(String.init)
                let date: String = dateTime[0]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                refuel.date = dateFormatter.date(from: date)
                
                refuel.distance = Double(csvRows[index][1])!
                refuel.volume = Double(csvRows[index][2])!
                refuel.full = Bool(csvRows[index][3])!
                refuel.price = Double(csvRows[index][4])!
                
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        } catch {
            fatalError("Can't load \(String(describing: path)) file")
        }
        
        tableView.reloadData()
    }
    
    func deleteAllCoreData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Refuel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
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
            //without ordering by date
            //let refuels = try context.fetch(Refuel.fetchRequest())
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
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let refuels = getRefuelsFromCoreData()

        return refuels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefuelTableViewCell", for: indexPath) as! RefuelTableViewCell

        let refuels = getRefuelsFromCoreData()
        if refuels.count > 0 {
            let refuel = refuels[indexPath.row]
            cell.volumeLabel?.text = "\(refuel.volume)ℓ"
            if refuel.distance != -1 {
                cell.distanceLabel?.text = "\(refuel.distance)km"
            } else {
                cell.distanceLabel?.text = ""
            }
            cell.dateLabel?.text = dateToString(date: refuel.date)
            cell.tankImageView.image = fullOrEmptyTankImage(full: refuel.full)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            var refuels = getRefuelsFromCoreData()

            context.delete(refuels[indexPath.row] )
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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

    
    //MARK: - Show Cell Assist
    func dateToString(date: Date?) -> String? {
        if (date != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            return dateFormatter.string(from: date!)
        }
        return nil
    }
    
    func fullOrEmptyTankImage(full: Bool) -> UIImage {
        if full {
            return UIImage(imageLiteralResourceName: "fulltank_step2")
        } else {
            return UIImage(imageLiteralResourceName: "emptytank_step1")
        }
    }

}


