//
//  ImageView.swift
//
//
//  Created by Sourabh Bhardwaj on 15/06/24.
//

import Foundation
import SwiftUI
import CoreKit
import Kingfisher

struct ImageView: View {
    
    var imageUrlString: String
    @State var isImageLoaded = false
    
    init(imageUrlString: String) {
        self.imageUrlString = imageUrlString
    }
    
    var body: some View {
        KFImage(URL(string: imageUrlString))
            .resizable()
            .placeholder {
                Image(systemName: "photo")
                    .font(.largeTitle)
            }
            .onSuccess { _ in
                isImageLoaded = true
            }
            .onFailure { _ in
                isImageLoaded = true
            }
        
        /*RemoteImageView(
            urlString: imageUrlString,
            placeholder: {
                Image(systemName: "photo")
                    .font(.largeTitle)
            },
            image: {
                $0
                    .resizable()
            }
        )*/
         
        /*AsyncImage(url: URL(string: imageUrlString).value) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }*/
    }
}

#Preview {
    ImageView(imageUrlString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}
