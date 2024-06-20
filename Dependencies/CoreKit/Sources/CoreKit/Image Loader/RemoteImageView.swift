//
//  RemoteImageView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import SwiftUI
import Kingfisher

public struct RemoteImageView<Placeholder: View, ConfiguredImage: View>: View {
    @ObservedObject var imageLoader: ImageLoader
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage
    
    public init(urlString: String,
                @ViewBuilder placeholder: @escaping () -> Placeholder,
                @ViewBuilder image: @escaping (Image) -> ConfiguredImage) {
        self.imageLoader = ImageLoader()
        self.placeholder = placeholder
        self.image = image
        self.imageLoader.load(from: urlString)
    }
    
    public var body: some View {
        Group {
            if let uiImage = imageLoader.image {
                image(Image(uiImage: uiImage).resizable())
            } 
            else {
                placeholder()
            }
        }
    }
}

