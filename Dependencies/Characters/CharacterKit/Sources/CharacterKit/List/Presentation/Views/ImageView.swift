//
//  ImageView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI
import CoreKit

struct ImageView: View {
    
    var imageUrlString: String
    
    init(imageUrlString: String) {
        self.imageUrlString = imageUrlString
    }
    
    var body: some View {
        RemoteImageView(
            urlString: imageUrlString,
            placeholder: {
                Image(systemName: "photo")
                    .font(.largeTitle)
            },
            image: {
                $0
                    .resizable()
            }
        )
    }
}

#Preview {
    ImageView(imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}
