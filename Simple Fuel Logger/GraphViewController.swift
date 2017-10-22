//
//  GraphViewController.swift
//  Simple Fuel Logger
//
//  Created by Master on 20/10/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let graphView = ScrollableGraphView(frame: frame, dataSource: self)

        // Do any additional setup after loading the view.
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        //let months2 = ["0.0":"Jan", "1.0":"Feb", "2.0":"Mar", "3.0":"Apr", "4.0":"May", "5.0":"Jun"]

        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        /*
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            //let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }*/
        
        //let values = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) * 100.0 }
        let labels = dataPoints
        let dataEntries = values.enumerated().map { x, y in return PieChartDataEntry(value: y, label: labels[x]) }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(values: dataEntries, label: "       Hello")
        data.addDataSet(ds1)
        //ds1.colors = ChartColorTemplates.liberty()

        ds1.colors = [ChartColorTemplates.colorFromString("#52FFA300"), ChartColorTemplates.colorFromString("#52EDB521") , ChartColorTemplates.colorFromString("#52DBC742"), ChartColorTemplates.colorFromString("#52C9D963") , ChartColorTemplates.colorFromString("#52B7EA84"), ChartColorTemplates.colorFromString("#52A5FFA6") ]
        ds1.valueTextColor = ChartColorTemplates.colorFromString("#FF000000")
        
        //let pieChartData = PieChartData(dataSet: pieChartDataSet)
        //let pieChartdata = PieChartDataEntry(
        //pieChartData.setValuesForKeys(dataPoints)
        //let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet) {
        pieChartView.data = data
        //}
        
        /*
        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors */
 
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        //let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
 
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
