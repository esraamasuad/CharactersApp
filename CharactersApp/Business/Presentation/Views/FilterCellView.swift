//
//  FilterCellView.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/21/24.
//

import SwiftUI

struct FilterCellView: View {
    
     var item: String
     var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(item).bold()
            Spacer()
        }
        .padding(.horizontal,15)
        .padding(.vertical,5)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill((isSelected) ? Color.cyan : Color.white)
            RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(Color.gray, lineWidth: 0.5)
        }
    }
}

#Preview {
    FilterCellView(item: Status.alive.rawValue, isSelected: true)
}
