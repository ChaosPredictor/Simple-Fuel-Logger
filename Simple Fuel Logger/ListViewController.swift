//
//  ListViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 06/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func saveRefuel(_ sender: UIBarButtonItem) {
    }
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
            
            do {
                let refuels = try context.fetch(Refuel.fetchRequest())
 
                if let refuel = (refuels[indexPath.row] as? Refuel) {
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
                }

            } catch {
                print("Fetching Failed")
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
        if editingStyle == .delete {
            print("Deleted")
            do {
                print("try1")
                var refuels = try context.fetch(Refuel.fetchRequest())
                print("try2")
                
                print("index path: \(indexPath.row)")
                print("leng1: \(refuels.count)")
                context.delete(refuels[indexPath.row] as! Refuel)
                refuels.remove(at: indexPath.row)
                print("leng2: \(refuels.count)")
                print("try3")
                do {
                    try context.save()
                    print("refuel saved")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                print("not try1")

            } catch {
                print("no refuels")
            }

            
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            print("not try2")
            tableView.reloadData()
            print("not try3")

        }
    }
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            var refuels = try context.fetch(Refuel.fetchRequest())

            if editingStyle == UITableViewCellEditingStyle.delete {
                refuels.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            
        } catch {
            print("error 2")
        }
        

    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("list view controller loaded")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
