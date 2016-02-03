//
//  ViewController.swift
//  Calculator
//
//  Created by Omer Yetik on 27/12/15.
//  Copyright © 2015 Omer Yetik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    // Assignment #1, Required Task #4, history label...
    @IBOutlet weak var historyPane: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            // following if clause -> Assignment #1, Req. task #2, fixed-point allowance
            if !(digit == "." && display.text?.rangeOfString(".") != nil) {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else { // error condition, if the result is not meaningful, return nil...
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else { // error condition, if the result is not meaningful, return nil...
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            //Assignment #1, Required Task #4, history..
            historyPane.text = brain.showStack()
            //
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    // Assignment #1, Required Task #5, C button...
    @IBAction func clear() {
        displayValue = 0
        historyPane.text = " "
        brain.clear()
    }
    //
}

