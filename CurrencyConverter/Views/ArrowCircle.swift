//
//  ArrowCircle.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import SwiftUI

struct ArrowCircle: View {
    let iconName: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle().foregroundColor(color).frame(width: 42, height: 42, alignment: .center)
            Image(systemName: iconName)
                .font(Font.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
