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
        // Assignmnet #1, Extra Credit Task #2, "=" sign...
        historyPane.text = historyPane.text! + "="
        //
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else { // error condition, if the result is not meaningful, return nil...
            displayValue = 0
        }
    }
    
    var displayValue: Double? {
        get {
            // Assignment #1, Extra Credit Task #4
            if let displayText = display.text {
                if let displayNumber = NSNumberFormatter().numberFromString(displayText) {
                    return displayNumber.doubleValue
                }
            }
            return nil
            //
        }
        set {
            // Assignment #1, Extra Credit Task #4
            display.text = newValue != nil ? "\(newValue!)" : "0"
            //
            // Assignment #1, Required Task #4, history..
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
    
    // Assignment #1, Extra Credit Task #1, Backspace Function..
    @IBAction func backSpace() {
        if userIsInTheMiddleOfTypingANumber {
            if display.text?.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
            } else {
                display.text = "0"
            }
        }
    }
    
    // Assignment #1, Extra Credit Task #3, plus/minus sign..
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if let rangeOfStringToDrop = display.text?.rangeOfString("-") {
                display.text?.removeRange(rangeOfStringToDrop)
            } else {
                display.text = "-" + display.text!
            }
        } else {
            self.operate(sender)
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
}

