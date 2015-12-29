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
    // outlet for history label, Assignment #1, Req. task #4
    @IBOutlet weak var historyPane: UILabel!
    //
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
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
        // the if check is added as requested in Assignment #1, Extra Credit #2
        if let rangeOfStringToRemove = (historyPane.text!.rangeOfString("=")) {
            historyPane.text?.removeRange(rangeOfStringToRemove)
        }
        //
        // add operation to history, Assignment #1, Req. task #4
        historyPane.text = historyPane.text! + digit
        //
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }

        // add operation to history, Assignment #1, Req. task #4
        historyPane.text = historyPane.text! + operation
        //
        // the if check and the final "=" sign in last assignment are added as
        // requested in Assignment #1, Extra Credit #2
        if let rangeOfStringToRemove = (historyPane.text!.rangeOfString("=")) {
            historyPane.text?.removeRange(rangeOfStringToRemove)
        }
        if operandStack.count > 0 {
            historyPane.text = historyPane.text! + " ="
        }
        //

        switch operation {
        case "×" : performOperation { $0 * $1 }
        case "÷" : performOperation { $1 / $0 }
        case "−" : performOperation { $1 - $0 }
        case "+" : performOperation { $0 + $1 }
        case "√" : performOperation { sqrt($0) }
        // add new operations, Assginment #1, Req. task #3
        case "sin" : performOperation { sin($0) }
        case "cos" : performOperation { cos($0) }
        case "π" : performOperation(operation) { self.getValueForConstant($0)}
        //
        default: break
        }

    }
    
    func performOperation(operation: (Double, Double) -> Double ) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc func performOperation(operation: (Double) -> Double ) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // add new operations, Assginment #1, Req. task #3
    @nonobjc func performOperation(constant: String, operation: (String) -> Double ) {
        displayValue = operation(constant)
        enter()
    }
    
    func getValueForConstant (constant: String) -> Double {
        var returnValue = 0.0
        switch constant {
        case "π" : returnValue = M_PI
        default: break
        }
        return returnValue
    }
    //
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        // add operation to history, Assignment #1, Req. task #4
        historyPane.text = historyPane.text! + " "
        //
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    // Clear function. Assignment #1, Required Task #5
    @IBAction func clear() {
        displayValue = 0
        operandStack = []
        historyPane.text = " "
    }
    
    // Backspace function. Assignment #1, Extra Credit #1
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if display.text?.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
                historyPane.text! = String(historyPane.text!.characters.dropLast())
            } else {
                display.text = "0"
            }
        }
    }
    //
}

