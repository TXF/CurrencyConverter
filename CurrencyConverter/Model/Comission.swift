//
//  Comission.swift
//  CurrencyConverter
//
//  Created by David on 23.08.2022.
//

import Foundation

protocol CommissionRule {
    func comissionFee(from: Double) -> Double
    func applyComission(for amount: Double) -> Double
}

class FixedPriceComission: CommissionRule {
    
    private let comissionFee: Double
    
    init(_ comission: Double) {
        comissionFee = comission
    }
    
    func comissionFee(from: Double) -> Double {
        return from / 100 * comissionFee
    }
    
    func applyComission(for amount: Double) -> Double {
        comissionFee(from: amount)
    }
}

class FreeAttemptsComission: FixedPriceComission {
    private var freeConversionAttempt: UInt
    
    init(_ comission: Double, freeAtempts: UInt) {
        freeConversionAttempt = freeAtempts
        super.init(comission)
    }
    
    override func comissionFee(from: Double) -> Double {
        if freeConversionAttempt > 0 {
            return 0
        } else {
            return super.comissionFee(from: from)
        }
    }
    
    override func applyComission(for amount: Double) -> Double {
        if freeConversionAttempt > 0 {
            freeConversionAttempt -= 1
        }
        
        return comissionFee(from: amount)
    }
}

class ComissionCalculator {
    private var comissionRules: [Currency.Symbol: CommissionRule] = [:]
    
    // MARK: Comission rules
    
    init(comissionRules:  [Currency.Symbol: CommissionRule]) {
        self.comissionRules = comissionRules
    }
    
    func addComissionRule(for symbol: Currency.Symbol, rule: CommissionRule) {
        comissionRules[symbol] = rule
    }
    
    // MARK: Comission handlers
    
    func commissionFee(currency: Currency) -> Double {
        comissionRules[currency.symbol]?.comissionFee(from: currency.value) ?? 0
    }
    
    func applyComission(for currency: Currency, amount: Double) {
        currency.value -= comissionRules[currency.symbol]?.applyComission(for:amount) ?? 0
    }
}
