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
            }, image: {
                $0
                    .resizable()
                    .renderingMode(.original)
                    //.aspectRatio(contentMode: .fit)
        })
        //.frame(width: 134, height: 134)
        .cornerRadius(5)
        
        /*AsyncImage(url: URL(string: imageUrlString)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            case .success(let image):
                image
                    .resizable()
            default:
                ProgressView()
            }
        }
        .frame(width: 144, height: 144)
        .clipShape(.rect(cornerRadius: 5))*/
    }
}

#Preview {
    ImageView(imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}
