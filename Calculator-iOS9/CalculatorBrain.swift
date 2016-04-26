//
//  CalculatorBrain.swift
//  Calculator-iOS9
//
//  Created by luojie on 16/4/24.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        internalProgram.append(operand)
        accumulator = operand
    }
    
    private var operations = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+": Operation.BinaryOperation(+),
        "−": Operation.BinaryOperation(-),
        "×": Operation.BinaryOperation(*),
        "÷": Operation.BinaryOperation(/),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePdingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePdingBinaryOperation()
            }
        }
    }
    
    private func executePdingBinaryOperation() {
        if let pending = pending {
            accumulator = pending.binaryFunction(pending.firstOperand, accumulator)
            self.pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let ops = newValue as? [AnyObject] {
                for op in ops {
                    if let oprand = op as? Double {
                        setOperand(oprand)
                    } else if let symbol = op as? String {
                        performOperation(symbol)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        return accumulator
    }
    
    
    
}