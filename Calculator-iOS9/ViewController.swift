//
//  ViewController.swift
//  Calculator-iOS9
//
//  Created by luojie on 16/4/23.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Calculator increase with count: \(calculatorCount)")
        brain.addUnaryOperation("Z") { [unowned self] in
            self.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator decrease with count: \(calculatorCount)")
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            display.text! += digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var program: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        program = brain.program
    }
    
    @IBAction func restore() {
        if program != nil {
            brain.program = program!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }

}

