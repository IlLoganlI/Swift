//
//  ScatterChart.swift
//  SwiftCM
//
//  Created by Logan on 07.10.17.
//  Copyright © 2017 Logan. All rights reserved.
//

import UIKit
import Charts

    // Comment (IhorYachmenov): sorry, but I could not create a scatter diagram :(


class ScatterChart: UIViewController {

    @IBOutlet weak var scatterChart: ScatterChartView!
    
    var renderer: DataRenderer?
    var _data: ChartData?
    var _animator: Animator!
    var _viewPortHandler: ViewPortHandler!
    
    var viewPortHandler: ViewPortHandler?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        
        let r = CGRect(x: 0, y: 0, width: 600, height: 600)
        let chartView = ScatterChartView(frame: r)
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = NSUIFont(name: "HelveticaNeue-Light", size: 10.0)!
        xAxis.drawGridLinesEnabled = true
        
        var scatterData: ScatterChartData? { return _data as? ScatterChartData }
        
        renderer = ScatterChartRenderer(dataProvider: self as? ScatterChartDataProvider, animator: _animator, viewPortHandler: _viewPortHandler)
        
        xAxis.spaceMin = 0.5
        xAxis.spaceMax = 0.5
        
        //
        
//        let r = CGRect(x: 0, y: 0, width: 600, height: 600)
//        let chartView = ScatterChartView(frame: r)
        
        chartView.drawGridBackgroundEnabled = false
        chartView.setScaleEnabled ( true)
        chartView.maxVisibleCount = 200
        
//        let xAxis = chartView.xAxis
//        xAxis.labelFont = NSUIFont(name: "HelveticaNeue-Light", size: 10.0)!
//        xAxis.drawGridLinesEnabled = true
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = NSUIFont(name: "HelveticaNeue-Light", size: 10.0)!
        leftAxis.axisMinimum = 0.0
        
        chartView.rightAxis.enabled = false
        
        
        
        
        
        let count = 25
        let range = 100.0
        
        var yVals1 = [ChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        var yVals3 = [ChartDataEntry]()
        
        
        for i in 0..<count
        {
            
            var val = Double(arc4random_uniform(UInt32(range))) + 3
            yVals1.append(ChartDataEntry(x: Double(i), y: val))
            val = Double(arc4random_uniform(UInt32(range))) + 3
            yVals2.append(ChartDataEntry(x: Double(i) + 0.33, y: val))
            val = Double(arc4random_uniform(UInt32(range))) + 3
            yVals3.append(ChartDataEntry(x: Double(i) + 0.66, y: val))
        }
        
        let set1 = ScatterChartDataSet(values: yVals1, label: "DS 1")
        set1.setScatterShape(.square )
        set1.colors =  ChartColorTemplates.liberty()
        set1.scatterShapeSize = 10.0
        
        let set2 = ScatterChartDataSet(values: yVals2, label: "DS 2")
        set2.setScatterShape( .circle)
        set2.scatterShapeHoleColor = NSUIColor.blue
        set2.scatterShapeHoleRadius = 3.5
        set2.colors = ChartColorTemplates.material()
        set2.scatterShapeSize = 10.0
        
        let set3 = ScatterChartDataSet(values: yVals3, label: "DS 3")
        set3.setScatterShape(.triangle)
        set3.colors = [NSUIColor.orange] //ChartColorTemplates.pastel()
        set3.scatterShapeSize = 10.0
        
        var dataSets = [ScatterChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        
        let data = ScatterChartData(dataSets: dataSets)
        data.setValueFont( NSUIFont(name: "HelveticaNeue-Light", size: CGFloat(7.0)))
        chartView.data = data
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        //1
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
}


