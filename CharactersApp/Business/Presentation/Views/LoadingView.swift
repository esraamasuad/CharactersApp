//
//  LoadingView.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/21/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading").progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}
