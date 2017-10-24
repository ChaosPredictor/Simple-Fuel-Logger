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

        let unitsSold = [20.0, 4.0, 6.0, 0.0, 12.0, 16.0]
        
        setChart(labels: months, values: unitsSold)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart(labels: [String], values: [Double]) {
        
        let dataEntries = values.enumerated().map { index, value in return PieChartDataEntry(value: value, label: labels[index]) }

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        
        pieChartDataSet.colors = [ChartColorTemplates.colorFromString("#52FFA300"), ChartColorTemplates.colorFromString("#52EDB521") , ChartColorTemplates.colorFromString("#52DBC742"), ChartColorTemplates.colorFromString("#52C9D963") , ChartColorTemplates.colorFromString("#52B7EA84"), ChartColorTemplates.colorFromString("#52A5FFA6") ]
        pieChartDataSet.valueTextColor = ChartColorTemplates.colorFromString("#FF000000")

        let pieChartData = PieChartData()
        pieChartData.addDataSet(pieChartDataSet)

        pieChartView.data = pieChartData

        
        /*
        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }*/

        var lineDataEntries : [ChartDataEntry] = []

         for index in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(index), y: values[index])
            lineDataEntries.append(dataEntry)
         }
         /*
        pieChartDataSet.colors = colors */
 
        let lineChartDataSet = LineChartDataSet(values: lineDataEntries, label: "Units Sold")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        //let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        lineChartView.xAxis.granularity = 1.0
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bothSided
        lineChartView.backgroundColor = ChartColorTemplates.colorFromString("#FFF3F3F3")
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
