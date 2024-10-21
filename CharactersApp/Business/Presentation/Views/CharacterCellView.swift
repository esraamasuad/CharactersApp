//
//  CharacterCellView.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import SwiftUI

struct CharacterCellView: View {
    
     var item: CharacterModel
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack {
                ImageFisher(url: (item.image ?? ""))
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading) {
                    Text(item.name ?? "").bold()
                    Text(item.species ?? "")
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.gray, lineWidth: 0.5))
    }
}

#Preview {
    CharacterCellView(item: CharacterModel(id: 0, name: "test", status: Status.alive, species: "test species", type: "test type", gender: "male", origin: nil, location: nil, image: nil, episode: nil, url: nil, created: nil))
}
