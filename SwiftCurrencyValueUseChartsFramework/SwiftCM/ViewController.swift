//
//  ViewController.swift
//  SwiftCM
//
//  Created by Logan on 05.10.17.
//  Copyright © 2017 Logan. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    // Comment (IhorYachmenov): function for move between display
    @IBAction func BarChart(_ sender: Any) {
        let manhinh = storyboard?.instantiateViewController(withIdentifier: "BarChart")
        navigationController?.pushViewController(manhinh!, animated: true)
        
    }

    @IBAction func ScatterChart(_ sender: Any) {
        let manhinh = storyboard?.instantiateViewController(withIdentifier: "ScatterChart")
        navigationController?.pushViewController(manhinh!, animated: true)
    }
    
    @IBAction func TableView(_ sender: Any) {
        let manhinh = storyboard?.instantiateViewController(withIdentifier: "TableView")
        navigationController?.pushViewController(manhinh!, animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

