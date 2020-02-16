//
//  Calculator.swift
//  CountOnMe
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//


import Foundation
protocol CalculatorComunication: class {
    func updateResult(calculString: String)
    func displayAlert(message: String)
}

final class Calculator {
    
    weak var delegate: CalculatorComunication?
    
    var calculString = "1 + 1 = 2" {
        didSet {
            delegate?.updateResult(calculString: calculString)
        }
    }
    
    var elements: [String] {
        //Separate calcul by "" and loop inside
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" || elements.last != "-" || elements.last != "÷" || elements.last != "x"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "x"
    }
    
    var canStartByOperator: Bool {
        if calculString >= "0" && calculString <= "9" {
            return elements.count >= 1
        } else {
            delegate?.displayAlert(message: "S'il vous plait ne commencer pas par un operateur !")
        }
        return false
    }
    
    var canFinishByOperator: Bool {
        return calculString.last == "+" && calculString.last == "-" && calculString.last == "÷" && calculString.last == "x"
    }
    var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
    }
    
    var divideByZero: Bool {
        return calculString.contains("÷ 0")
    }
    
    func addition() {
        if canStartByOperator {
            if canAddOperator {
                calculString.append(" + ")
            } else { delegate?.displayAlert(message: "Un operateur est déja mis !") }
        }
    }
    func substraction() {
        if canStartByOperator {
            if canAddOperator {
                calculString.append(" - ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        }
    }
    func division() {
        if canStartByOperator {
            if canAddOperator {
                calculString.append(" ÷ ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        }
    }
    
    func multiplication() {
        if canStartByOperator {
            if canAddOperator {
                calculString.append(" x ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        }
    }
    
    func equal() {
        
        guard expressionIsCorrect else {
            delegate?.displayAlert(message: "Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            delegate?.displayAlert(message: "Demarrez un nouveau calcul !")
            return
        }
        
        guard !divideByZero else {
            delegate?.displayAlert(message: "Il est impossible de diviser par zéro !")
            calculString = ""
            return
        }
        
        guard canFinishByOperator else {
            delegate?.displayAlert(message: "Malheureusement il est impossible de finir par un operateur")
            calculString = ""
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            guard var left = Float(operationsToReduce[0]) else { return }
            var operand = operationsToReduce[1]
            guard var right = Float(operationsToReduce[2]) else { return }
            
            let result: Float
            
            var operandIndex = 1 // Start at one for we can remove extra calcul for priorities
            
            // Search if there is multiply of divide then assign index
            if let index = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) {
                
                operandIndex = index
                if let leftunwrapp = Float(operationsToReduce[index - 1]) { left = leftunwrapp }
                operand = operationsToReduce[index]
                if let rightUnwrapp = Float(operationsToReduce[index + 1]) { right = rightUnwrapp }
            }
            
            result = calculate(left: left, right: right, operand: operand)
            
            
            for _ in 1...3 { // Loop inside index to remove extra operator
                
                operationsToReduce.remove(at: operandIndex - 1)
                print(operationsToReduce)
                print(result)
            }
            operationsToReduce.insert("\(result)", at: operandIndex - 1 )
            print(operationsToReduce)
        }
        guard let finalResult = operationsToReduce.first else { return }
        calculString.append(" = \(finalResult)")
    }
    
    func calculate(left: Float, right: Float, operand: String) -> Float {
        
        var result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "÷": result = left / right
        case "x": result = left * right
        default: return 0.0
        }
        //        if let resultInt = result.truncatingRemainder(dividingBy: 1) == 0 {
        //            return resultInt(Int)
        //        } else {
        //            return result
        //        }
        return result
        
    }
    
    func tapNumberButton(numberText: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numberText)
    }
    
    func reset() {
        calculString = ""
    }
}

