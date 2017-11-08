//
//  TableViewController.swift
//  SwiftCM
//
//  Created by Logan on 08.10.17.
//  Copyright © 2017 Logan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var strongWeakPairData = [String]()
    var strongestData = [String]()
    var timeFrameData = [String]()
    var weakestData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let key = ["SymbolIndices"]
        self.parseJsonData(key: key)
    }
 

    func parseJsonData(key currencyCourseAfter: Array<String>) {
        
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
                                    
                                    let strongWeakPair = value["StrongWeakPair"] as? String
                                    let strongest = value["Strongest"] as? String
                                    let timeFrame = value["TimeFrame"] as? String
                                    let weakest = value["Weakest"] as? String
                                    self.strongWeakPairData.append(strongWeakPair!)
                                    self.strongestData.append(strongest!)
                                    self.timeFrameData.append(timeFrame!)
                                    self.weakestData.append(weakest!)
                                }
                                print(self.strongWeakPairData)
                                
                            }
                        }
                    } catch { print("Error deserializing JSON: \(error)") }
                }
            }
            
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
            
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return strongWeakPairData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        cell.timeFrameLabel.text = timeFrameData[indexPath.row]
        cell.strongestLabel.text = strongestData[indexPath.row]
        cell.weakestLabel.text = weakestData[indexPath.row]
        cell.strongWeakPairLabel.text = strongWeakPairData[indexPath.row]
      
        return (cell)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
