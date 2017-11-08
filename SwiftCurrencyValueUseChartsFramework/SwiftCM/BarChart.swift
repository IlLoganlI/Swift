//
//  BarChart.swift
//  SwiftCM
//
//  Created by Logan on 05.10.17.
//  Copyright © 2017 Logan. All rights reserved.
//

import UIKit
import Charts

class BarChart: UIViewController {

    
    @IBOutlet weak var dropMenu: DropMenuButton!
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Comment(IhorYachmenov): initialize drop down menu and adding her key for redrawing chart
        dropMenu.initMenu(["15 MIN", "1 HOUR", "4 HOUR", "1 DAY"], actions: [({ () -> (Void) in
            let timeListForM15 = ["M15"]
            self.parseJsonData(time: timeListForM15)
            print("1 complete!")
            
        }), ({ () -> (Void) in
            let timeListForH1 = ["H1"]
            self.parseJsonData(time: timeListForH1)
            
        }), ({ () -> (Void) in
            let timeListForH4 = ["H4"]
            self.parseJsonData(time: timeListForH4)
            
        }), ({ () -> (Void) in
            let timeListForD1 = ["D1"]
            self.parseJsonData(time: timeListForD1)
            
        })])

        
    }
    
    //Comment(IhorYachmenov): parsing json data(only M15 H1 H4 D1) and adding their to array
    func parseJsonData(time currencyCourseAfter: Array<String>) {
        
        var dataForTable: [Int] = []
        var nameForBar: [String] = []
        
        let url = URL(string: "http://34.197.213.118:20019/fxservice/strongweak")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Error")
            } else {
                if let mydata = data  {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: mydata, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        for time in currencyCourseAfter {
                            if let myObj = json[time]  as? [[String: Any]]
                            {
                                
                                for value in myObj {
                                    
                                    let nameOfValue = value["Key"] as? String
                                    let courseOfValue = value["Value"] as? Int
                                    dataForTable.append(courseOfValue!)
                                    nameForBar.append(nameOfValue!)
                                }
                                self.outputDataInTable(name: nameForBar, data: dataForTable)
                            }
                        }
                    } catch { print("Error deserializing JSON: \(error)") }
                }
            }
        }
        task.resume()

    }

    //Comment(IhorYachmenov): added data to display in bar chart
    func outputDataInTable(name nameForBar: Array<String>, data dataForTable: Array<Int>) {
        
        var dataArray : [BarChartDataEntry] = []
        
        for i in 0..<nameForBar.count {
            let data : BarChartDataEntry = BarChartDataEntry (x: Double(i), yValues: [(Double(dataForTable[i]))])
            dataArray.append(data)
        }
        
        let dataset : BarChartDataSet = BarChartDataSet(values: dataArray, label: "Bat Chart")
        dataset.setColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))
        let dataChart : BarChartData = BarChartData(dataSet: dataset)
        self.barChart.data = dataChart
        self.barChart.animate(xAxisDuration: 2, easingOption: .easeInBounce)
        self.barChart.animate(yAxisDuration: 2, easingOption: .easeInBounce)
        
        print(dataForTable, nameForBar)
    }
    
}
