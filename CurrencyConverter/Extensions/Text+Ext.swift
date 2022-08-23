//
//  UIView+Ext.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import SwiftUI

struct SectionHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(Design.Colors.header))
            .font(.system(size: 15, weight: .semibold, design: .default))
    }
}

struct RoundedButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.system(size: 18, weight: .medium))
            .padding()
            .foregroundColor(.white)
    }
}

extension Text {
    func sectionStyle() -> some View {
        modifier(SectionHeader())
    }
    
    func roundedButtonStyle() -> some View {
            modifier(RoundedButtonModifier())
    }
}
