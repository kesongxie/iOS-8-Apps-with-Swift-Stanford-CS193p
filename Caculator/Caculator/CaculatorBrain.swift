//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by Xie kesong on 4/21/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import Foundation

//this is the model


class CalculatorBrain:Printable{
    //make this enum type printable, and require to have description property,
    //so we can use println() and print whatever the description returns, similar to toString
    //differences between class and enum, enums are passed by value, while class are passed by reference
    //class can inherit, while enum can not
    var description: String{
        get{
            var paramOpstack = opStack
            var outPut = ""
            var start = true
            while(!paramOpstack.isEmpty){
               if let result = brainDescription(&paramOpstack).op{
                    if start{
                        outPut = result + outPut
                        start = false
                    }else{
                        outPut = result + "," + outPut
                    }
                }
            }
            return outPut
        }
    }
   
    private enum Op:Printable{
        case Operand(Double) //Pass a associative value to the enum case
        case VariableOperand(String) //allow users to push varible to the stack
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String,(Double,Double)->Double)
        case constantValues(String, Double)
        
        var precedence: Int{
            get{
                switch self{
                case .BinaryOperation(_, _):
                    return 1
                default:
                    return 0
                }
            }
        }
        
        var description: String{
            //required property for printable protocal
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .VariableOperand(let operand):
                    return operand
                case .UnaryOperation(let unary, _):
                    return unary
                case .BinaryOperation(let binary, _):
                    return binary
                case .constantValues(let constant, _):
                    return constant
                }
            }
        }
    }
    
    //a stack contains enum type
    private var opStack = [Op]()
    private var errorMessage:String?
    private var variableNotSet = false
    
    //a dictionary that uses String as key, and its value is a enum Op
    private var knownOps = [String:Op]()
    var varibleValues = [String:Double]()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        //save operator to the dictionary knownOp
        learnOp(Op.BinaryOperation("×",*)) // "x" and * are associative value for enum
        learnOp(Op.BinaryOperation("÷"){$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−"){$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt)) //type inference, double->double
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.constantValues("π", M_PI))
    }
    
    
    private func brainDescription(inout paramOp:[Op])->(op:String?,precedence:Int,remaindingOps:[Op]){
        if !paramOp.isEmpty{
            let op = paramOp.removeLast()
            var desc:String = ""
            switch op{
            case .Operand(let operand):
                return ("\(operand)", 1 ,paramOp)
            case .constantValues(let constant, _):
                return (constant, 1 , paramOp)
            case .VariableOperand(let variable):
                return (variable, 1 , paramOp)
            case .UnaryOperation(let unary, _):
                let expression = brainDescription(&paramOp)
                if let operand = expression.op{
                    return ("\(unary)(\(operand))",1, expression.remaindingOps)
                }
            case .BinaryOperation(let binary, _):
                let expression1 = brainDescription(&paramOp)
                if let operand1 = expression1.op{
                    let expression2 = brainDescription(&paramOp)
                    if let operand2 = expression2.op{
                        if(expression2.precedence < getPrecedence(binary)){
                            desc+="(\(operand2)) \(binary) "
                        }else{
                            desc+="\(operand2) \(binary) "
                        }
                        
                        if(expression1.precedence < getPrecedence(binary)){
                            desc+="(\(operand1))"
                        }else{
                            desc+="\(operand1)"
                        }
                        return (desc,getPrecedence(binary),expression2.remaindingOps)
                    }else{
                        if(expression1.precedence < getPrecedence(binary)){
                            desc+="(\(operand1)) \(binary) "
                        }else{
                            desc+="\(operand1) \(binary) "
                        }
                        desc+="?"
                        return (desc,getPrecedence(binary),expression2.remaindingOps)
                    }
                }else{
                    return ("? \(binary) ?",getPrecedence(binary),paramOp)
                }
            }
        }
        return (nil,0, paramOp)
    }
    
    
    //return numeric precedence based upon the operator
    private func getPrecedence(op:String) -> Int{
        if(op == "×" || op == "÷"){
            return 1
        }else{
            return 0
        }
    }
    
    private func evaluable(operation:Op, operand:Double...) -> (evaluable:Bool , errorMessage:String?){
        switch operation{
        case .UnaryOperation(let oper, _):
            if operand.isEmpty{
                return (false,"\(oper) NEEDS ONE OPERAND")
            }else{
                if oper == "√" && operand[0] < 0{
                    return (false,"\(oper) REQUIRES THE ROOT TO BE NON-NEGATIVE ")
                }else{
                    return (true,nil)
                }
            }
        case .BinaryOperation(let oper, _):
            if countElements(operand) < 2{
                return (false, "\(oper) NEEDS TWO OPERANDS")
            }else{
                if oper == "÷" && operand[0] == 0 {
                    return (false,"\(oper) REQUIRES THE DENOMINATOR TO BE NON-ZERO ")
                }else{
                    return (true,nil)
                }
            }
        default:
            return (true,nil)
        }
    }
    
    private func evaluate(ops:[Op]) -> (result:Double?,remainingOps:[Op]){
        if !ops.isEmpty{
            // the defualt ops parameter is a constant let, and is passed by value, however, we need a mutable array, and we need a local mutable copy of the array
            var remainingOps = ops
            let op = remainingOps.removeLast() //since remainingOps is mutable, we can call the removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .VariableOperand(let operand):
                if let OperandValue = varibleValues[operand]{
                    variableNotSet = false
                    return (OperandValue, remainingOps)
                }else{
                    variableNotSet = true
                    errorMessage = "variable \(operand) is not set"
                }
            case .UnaryOperation(let oper, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand =  operandEvaluation.result{
                    let (eval,error) = evaluable(op, operand: operand)
                    if eval {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }else{
                        errorMessage = error
                    }
                }else{
                    errorMessage = "\(oper) REQUIRES ONE OPERAND"
                }
            case .BinaryOperation(let oper,let operation):
                let op1Evaluation =  evaluate(remainingOps)
                //if there is not enough operands in the stack, it runs to return(nil,ops)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        let (eval,error) = evaluable(op, operand: operand1, operand2)
                        if eval {
                            return (operation(operand1,operand2),op2Evaluation.remainingOps)
                        }else{
                            errorMessage = error
                        }
                    }else{
                        if !variableNotSet{
                            errorMessage = "\(oper) REQUIRES TWO OPERANDS"
                        }
                    }
                }else{
                    if !variableNotSet{
                        errorMessage = "\(oper) REQUIRES TWO OPERANDS"
                    }
                }
            case .constantValues(_, let constant):
                return (constant, remainingOps)
            }
        }
        
        return (nil,ops)
    }
    
    
    
    func evaluateAndReportErrors() -> (result:Double?, errorMessage:String?){
        let (result, remainder) = evaluate(opStack)
        if errorMessage != nil {
            return (nil, errorMessage)
        }else{
            return (result,nil)
        }
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(operand:String) -> Double?{
        opStack.append(Op.VariableOperand(operand))
        return evaluate()
    }
    
    func pushConstant(constant:String) -> Double?{
        if let const = knownOps[constant]{
            opStack.append(const)
        }
        return evaluate()
    }
    
    func popOp(){
         opStack.removeLast()
    }
    
    
    func performAction(symbol:String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearInput(){
        opStack.removeAll()
    }
    
    func getErorrMessage() -> String?{
        return errorMessage
    }
    
}