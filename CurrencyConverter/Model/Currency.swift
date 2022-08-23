//
//  Currencies.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import Combine

class Currency: ObservableObject {
    enum Symbol: String, CaseIterable {
        case EUR
        case JPY
        case USD
    }
    
    @Published var symbol: Symbol
    @Published var value: Double
    private var commission: CommissionRule?
    
    init(symbol: Symbol, value: Double, commission: CommissionRule? = nil) {
        self.value = value
        self.symbol = symbol
        self.commission = commission
    }
    
    func toString() -> String {
        "\(String(format: "%.2f", value)) \(symbol.rawValue)"
    }
}

extension Currency: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}

class Wallet {
    var currencies: [Currency]
    
    init(currencies: [Currency]) {
        self.currencies = currencies
    }
}
