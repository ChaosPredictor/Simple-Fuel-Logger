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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefuelTableViewCell", for: indexPath) as! RefuelTableViewCell

        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let refuel = Refuel(context: context) // Link Task & Context
        do {
            let refuels = try context.fetch(Refuel.fetchRequest())
            //let refuel = refuels[indexPath.row]
            
                            //(refuels[3] as AnyObject).volume
            
            //if let refuel = (refuels[indexPath.row] as AnyObject?) {
            //    cell.distanceLabel?.text = refuel.volume
            //}
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                print("in do")
                let refuels = try context.fetch(Refuel.fetchRequest())
                // if let volume = (refuels[1] as AnyObject).volume {
                //     print(volume)
                // }

                if var refuel2 = (refuels[indexPath.row] as? Refuel) {
                    if var volume = refuel2.volume as? Double {
                        cell.distanceLabel?.text = String(volume)
                    }
                    //print(volume)
                }

                
                /*
                if let volume = (refuels[indexPath.row] as! Refuel).volume {
                    //print(volume)
                    cell.distanceLabel?.text = volume
                }
                if let distance = (refuels[indexPath.row] as! Refuel).distance {
                    print(distance)
                }
                if let price = (refuels[indexPath.row] as! Refuel).price {
                    print(price)
                }*/
            } catch {
                print("Fetching Failed")
            }
            
            //if let volume = (refuels[indexPath.row] as! Refuel).volume {
            //    cell.distanceLabel?.text = volume
            //}
            
            //if let volume = (refuel as? AnyObject).volume {
            //    cell.textLabel?.text = volume
            //}
            return cell
        } catch {
            print("Fetching Failed")
        }
        

        
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RefuelTableViewCell")
        //cell.textLabel?.text = String("ar[indexPath.row]")

/*        let cellIdentifier = "RefuelTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)*/
        return cell
    }
    

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
