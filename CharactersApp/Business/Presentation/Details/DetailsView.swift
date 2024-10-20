//
//  DetailsView.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/19/24.
//

import SwiftUI

struct DetailsView: View {
    
    @StateObject var viewModel: DetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ImageFisher(url: viewModel.image)
                    .frame(height: 400)
                VStack {
                    HStack {
                        Text(viewModel.name).bold()
                        Spacer()
                        Text(viewModel.status).bold()
                            .frame(height: 40)
                            .padding(.horizontal, 20)
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.cyan))
                    }
                    HStack {
                        Text(viewModel.species)
                        Circle().fill(Color.black).frame(width: 10, height: 10)
                        Text(viewModel.gender)
                        Spacer()
                    }
                    HStack {
                        Text("Location:").bold()
                        Text(viewModel.location)
                        Spacer()
                    }
                }
                .padding(25)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.setUp()
            viewModel.getCharacterDetails()
        })
    }
}

//#Preview {
//   DetailsView()
//}
