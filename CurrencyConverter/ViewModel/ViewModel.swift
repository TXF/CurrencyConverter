//
//  ViewModel.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import Foundation
import Combine

enum AlertMessage {
    case insufficientSellAmount(String)
    case networkError(String)
    case exchangeSuccess(Currency, Currency, Double)
}

class ViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var showAlert = false
    @Published var changeCurencyAction: Bool = false {
        didSet {
            seeExchangeRate()
        }
    }
    
    @Published var sellCurrency: Currency = Currency(symbol: .EUR, value: 0) {
        didSet {
            if receiveCurrency.symbol == sellCurrency.symbol {
                receiveCurrency = Currency(symbol: oldValue.symbol, value: 0)
            }
        }
    }
    
    @Published var receiveCurrency: Currency = Currency(symbol: .USD, value: 0) {
        didSet {
            if receiveCurrency.symbol == sellCurrency.symbol {
                sellCurrency = Currency(symbol: oldValue.symbol, value: sellCurrency.value)
            }
        }
    }
    
    let wallet: Wallet
    
    var isSubmitEnabled: Bool {
        receiveCurrency.value > 0
    }
    
    lazy var currencies: [String] = {
        Currency.Symbol.allCases.map { $0.rawValue }
    }()
    
    private var observer: AnyCancellable?
    
    private var alertMessage: AlertMessage? {
        didSet {
            showAlert = alertMessage != nil
        }
    }
    
    private let comissionCalculator: ComissionCalculator
    
    // MARK: - Initialization
    
    init() {
        self.wallet = Wallet(currencies: [Currency(symbol: .USD, value: 1000),
                                          Currency(symbol: .EUR, value: 0),
                                          Currency(symbol: .JPY, value: 0)])
        
        comissionCalculator = ComissionCalculator(comissionRules:
                                                    [.USD: FreeAttemptsComission(0.7, freeAtempts: 5),
                                                     .EUR: FixedPriceComission(0.7)]
        )
    }
    
    // MARK: Actions
    
    func submitExchange() {
        let comissionFee = comissionCalculator.commissionFee(currency: sellCurrency).round(to: 2)
        let sellAmount = sellCurrency.value
        
        guard let walletSellCurrency = wallet.currencies.first(where: { $0.symbol == sellCurrency.symbol }),
              walletSellCurrency.value != 0,
              walletSellCurrency.value >= sellAmount + comissionFee else {
            alertMessage = .insufficientSellAmount(sellCurrency.symbol.rawValue)
            return
        }
        
        if let walletReceiveCurrency = wallet.currencies.first(where: { $0.symbol == receiveCurrency.symbol }) {
            comissionCalculator.applyComission(for: walletSellCurrency, amount: sellAmount)
            walletSellCurrency.value = walletSellCurrency.value - sellAmount
            walletReceiveCurrency.value = walletReceiveCurrency.value + receiveCurrency.value
        }
        
        alertMessage = .exchangeSuccess(sellCurrency, receiveCurrency, comissionFee)
    }
    
    func getAlertContent() -> AlerMessageContent {
        guard let alertInfo = alertMessage else { fatalError() }
        
        if case .exchangeSuccess(_,_,_) = alertInfo {
            return AlertMessageFactory.buildMessageContent(from: alertInfo, action: { [weak self] in
                self?.resetUserInput()
                self?.alertMessage = nil
            })
        } else {
            return AlertMessageFactory.buildMessageContent(from: alertInfo, action: { [weak self] in
                self?.alertMessage = nil
            })
        }
    }
    
    private func resetUserInput() {
        sellCurrency = Currency(symbol: sellCurrency.symbol, value: 0)
        receiveCurrency = Currency(symbol: receiveCurrency.symbol, value: 0)
    }
    
    private func seeExchangeRate() {
        guard sellCurrency.value != 0 else { return }
        
        observer = APICaller.shared.exchange(from: sellCurrency, to: receiveCurrency)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    self.alertMessage = .networkError(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] value in
                self.receiveCurrency = Currency(symbol: self.receiveCurrency.symbol, value: value.amount)
            })
    }
}
