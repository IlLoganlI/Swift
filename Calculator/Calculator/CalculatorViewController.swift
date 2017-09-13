//
//  ViewController.swift
//  Calculator
//
//  Created by Michel Deiman on 16/02/2017.
//  Updated by Michel Deiman on 14/03/2017.
//
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var backSpace_Undo: UIButton!
    @IBOutlet weak var memoryKey: UIButton!
    @IBOutlet weak var decimalSeparator: UIButton!
    @IBOutlet weak var graphBarButtonItem: UIBarButtonItem!
    
    private var brain = CalculatorBrain()

    var displayValue: Double {
        get {
            guard let valueString = display.text else { return 0.0 }
            let value = numberFormatter.number(from: valueString)
            return Double(value ?? 0)
        }
        set {
            display.text = numberFormatter?.string(from: newValue as NSNumber)
            brain.saveState(using: Keys.stateOfCalculator)
        }
    }
    
    var userIsInTheMiddleOfTyping = false {
        didSet {
            if userIsInTheMiddleOfTyping {
                backSpace_Undo.setTitle("⌫", for: .normal)
            } else {
                backSpace_Undo.setTitle("⋘", for: .normal)
            }
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
			let value = numberFormatter.number(from: display.text! + digit)
			display.text = numberFormatter.string(from: value!)
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction private func backSpace()
    {	if userIsInTheMiddleOfTyping {
            display.text = String(display.text!.characters.dropLast())
            if display.text?.characters.count == 0
            {	displayValue = 0.0
                userIsInTheMiddleOfTyping = false
            }
        } else {
            _ = brain.undo()
            evaluateExpression(using: variables)
        }
    }
    
    @IBAction func floatingPoint() {
        if !userIsInTheMiddleOfTyping {
            display.text = "0" + numberFormatter.decimalSeparator
        } else if !display.text!.contains(numberFormatter.decimalSeparator) {
            display.text = display.text! + numberFormatter.decimalSeparator
        }
        userIsInTheMiddleOfTyping = true
    }

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        evaluateExpression(using: variables)
    }
    
    private func evaluateExpression(using variables: Dictionary<String,Double>? = nil) {
        let evaluation = brain.evaluate(using: variables)
        if let result = evaluation.result {
            displayValue = result
        }
        userIsInTheMiddleOfTyping = false
        let postfixDescription = evaluation.isPending ? "..." : "="
        history.text = evaluation.description + postfixDescription
        graphBarButtonItem.tintColor = evaluation.isPending ? UIColor.gray : UIColor.blue
    }
    
    @IBAction private func clearAll()
    {	brain.clear()
        displayValue = 0.0
        history.text = " "
        variables = [:]
        memoryKey.setTitle("M", for: .normal)
    }
    
    // stores dictionary containing variables. 
    // Calculater sets just one variable, but to anticipate future use...
    private var variables: [String: Double] {
        get {
            if let storedVariables = UserDefaults.standard.dictionary(forKey: Keys.variables) {
                var variables: [String: Double] = [:]
                for (key, value) in storedVariables {
                    variables[key] = (value as? Double) ?? 0
                }
                return variables
            } else {
                return [:]
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.variables)
        }
    }
    
    // hit one of the memory buttons
    @IBAction func onMemory(_ sender: UIButton) {
        if let key = sender.currentTitle
        {   if key == "⇢M" {
                variables = ["M": displayValue]
                memoryKey.setTitle(display.text!, for: .normal)
                evaluateExpression(using: variables)
            } else {
                brain.setOperand(variable: "M")
                evaluateExpression(using: variables)
            }
        }
    }
    
    private weak var numberFormatter: NumberFormatter! = CalculatorBrain.DoubleToString.numberFormatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.minimumIntegerDigits = 1
        decimalSeparator.setTitle(numberFormatter?.decimalSeparator, for: .normal)
        if let keyValue = variables["M"] {
            memoryKey.setTitle(numberFormatter?.string(from: keyValue as NSNumber), for: .normal)
        }
        brain.loadState(using: Keys.stateOfCalculator)
        evaluateExpression(using: variables)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !brain.evaluate().isPending
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        brain.saveState(using: Keys.stateOfGraphViewVC)
    }
}

extension CalculatorViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool
    {
        return true
    }
}

extension CalculatorViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = traitCollection.verticalSizeClass == .compact
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		navigationController?.navigationBar.isHidden = traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular
	}
}

struct Keys {
    static let stateOfGraphViewVC = "GraphViewControllerState"
    static let stateOfCalculator = "CalculatorState"
    static let variables = "CalculatorVariables"
    static let segueToGraphVC = "segueToGraphVC"
}

