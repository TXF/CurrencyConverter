//
//  Number+Ext.swift
//  CurrencyConverter
//
//  Created by David on 23.08.2022.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
