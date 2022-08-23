//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by David on 21.08.2022.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
