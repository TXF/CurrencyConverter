//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by David on 21.08.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundImage = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1),
            colors: [Design.Colors.linearGradientStart.cgColor, Design.Colors.linearGradientEnd.cgColor])
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Currency converter")
                .navigationBarTitleDisplayMode(.inline)
        }.alert(isPresented: $viewModel.showAlert) {
            let content = viewModel.getAlertContent()
            
            return Alert(title: Text(content.title),
                         message: Text(content.message),
                         dismissButton: content.primaryButton)
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 36) {
            Text("my balances".uppercased()).sectionStyle()
            balanceView
            Text("currency exchange".uppercased()).sectionStyle()
            currencyExchangeView
            Button(action: {
                viewModel.submitExchange()
            }) {
                Text("submit".uppercased()).roundedButtonStyle()
            }
            .disabled(!viewModel.isSubmitEnabled)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(Design.Colors.linearGradientStart), Color(Design.Colors.linearGradientEnd)]),
                               startPoint: .leading, endPoint: .trailing).opacity(viewModel.isSubmitEnabled ? 1 : 0.5)
            )
            .cornerRadius(25)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 15))
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading], 15)
        .padding(.top, 30)
    }
    
    var balanceView: some View {
        let rows = [GridItem(.flexible(minimum: 100))]
        
        return ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(viewModel.wallet.currencies, id: \.self) { currency in
                    Text(currency.toString())
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.trailing, 15)
                }
            }.frame(height: 20)
        }
    }
    
    private var currencyExchangeView: some View {
        VStack(alignment: .leading, spacing: 20) {
            let currencyList = viewModel.currencies
            CurrenceExchangeRow(type: .sell,
                                selectedCurrency: $viewModel.sellCurrency,
                                changeCurencyAction: $viewModel.changeCurencyAction,
                                allCurrencies: currencyList)
            CurrenceExchangeRow(type: .buy,
                                selectedCurrency: $viewModel.receiveCurrency,
                                changeCurencyAction: $viewModel.changeCurencyAction,
                                allCurrencies: currencyList)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        ContentView(viewModel: viewModel)
    }
}
