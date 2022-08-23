//
//  AlertContentFactory.swift
//  CurrencyConverter
//
//  Created by David on 23.08.2022.
//

import SwiftUI

struct AlerMessageContent {
    let title: String
    let message: String
    let primaryButton: Alert.Button
}

class AlertMessageFactory {
    static func buildMessageContent(from type: AlertMessage, action: (() -> Void)? = {}) -> AlerMessageContent {
        switch type {
        case .insufficientSellAmount(let currency):
            return AlerMessageContent(title: "Info",
                                      message: "There is insufficient \(currency) on you account",
                                      primaryButton: .default(Text("Ok"), action: action))
            
        case .networkError(let message):
            return AlerMessageContent(title: "Error",
                                      message: message,
                                      primaryButton: .default(Text("Ok"), action: action))
            
        case .exchangeSuccess(let source, let target, let fee):
            return AlerMessageContent(title: "Success",
                                      message: "You have converted \(source.toString()) to \(target.toString()). Commission Fee - \(fee) \(source.symbol).",
                                      primaryButton: .default(Text("Ok"), action: action))
        }
    }
}
