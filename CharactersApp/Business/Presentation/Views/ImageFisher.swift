//
//  ImageFisher.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import SwiftUI
import Kingfisher

struct ImageFisher: View {
    var url:String
    
    let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 400))
                 |> RoundCornerImageProcessor(cornerRadius: 10)
    
    var body: some View {
        KFImage(URL(string: url))
            .placeholder {
                // Image("ic_placeholder").centerCropped()
            }
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .fade(duration: 1)
            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 64, height: 64)

    }
}

