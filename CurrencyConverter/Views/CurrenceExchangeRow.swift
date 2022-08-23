//
//  CurrenceExchangeRow.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import SwiftUI

struct CurrenceExchangeRow: View {
    enum ExchangeType {
        case sell
        case buy
    }
    
    @Binding private var selectedCurrency: Currency
    @Binding private var changeCurencyAction: Bool
    
    private var allCurrencies: [String]
    private var iconName: String
    private var color: Color
    private var text: String
    private var isAmountTextEditable: Bool
    private var cellType: ExchangeType
    @State private var textValue: String = ""
    
    private var menuListOptions: [String] {
        allCurrencies.filter {$0 != selectedCurrency.symbol.rawValue}
    }
    
    init(type: ExchangeType,
         selectedCurrency: Binding<Currency>,
         changeCurencyAction: Binding<Bool>,
         allCurrencies: [String]) {
        switch type {
        case .buy:
            iconName = "arrow.down"
            color = .green
            text = "Receive"
            isAmountTextEditable = false
        case .sell:
            iconName = "arrow.up"
            color = .red
            text = "Sell"
            isAmountTextEditable = true
        }
        
        self._changeCurencyAction = changeCurencyAction
        self._selectedCurrency = selectedCurrency
        self.cellType = type
        self.allCurrencies = allCurrencies
    }
    
    var body: some View {
        HStack (alignment: .center, spacing: 15) {
            ArrowCircle(iconName: iconName, color: color)
            VStack {
                HStack (alignment: .center, spacing: 25) {
                    Text(text)
                    TextField("", text: $textValue, onCommit: {
                        if let decimal = Double(textValue) {
                            selectedCurrency = Currency(symbol: selectedCurrency.symbol, value: decimal)
                            changeCurencyAction = true
                        }
                    })
                    .keyboardType(.numbersAndPunctuation)
                    .foregroundColor(currencyTextColor)
                    .multilineTextAlignment(.trailing)
                    .placeHolder(Text("0.0"), show: textValue == "")
                    Menu {
                        ForEach(menuListOptions, id: \.self) { currency in
                            Button {
                                selectedCurrency = Currency(symbol: Currency.Symbol(rawValue: currency)!, value: selectedCurrency.value)
                                changeCurencyAction = true
                            } label: {
                                Text(currency).font(.headline)
                            }
                        }
                    } label: {
                        Text(selectedCurrency.symbol.rawValue).frame(width: 40)
                        Image(systemName: "chevron.down").frame(width: 10)
                    }.foregroundColor(.black)
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 15))
                Divider().padding(.top , 5)
            }
        }.onChange(of: selectedCurrency.value) { value in
            if cellType == .buy {
                textValue =  value > 0 ? "+ \(value)" : ""
            } else {
                textValue = value > 0 ? String(value) : ""
            }
        }
    }
    
    private var currencyTextColor: Color {
        if cellType == .buy {
            return textValue != "" ? .green : .gray
        }
        return .black
    }
}
