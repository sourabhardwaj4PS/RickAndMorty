//
//  RemoteImageView.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import SwiftUI

public struct RemoteImageView<Placeholder: View, ConfiguredImage: View>: View {
    
    private let placeholder: () -> Placeholder
    private let image: (Image) -> ConfiguredImage
    
    var urlString: String

    @ObservedObject var imageLoader: ImageLoader
    @State var imageData: Image?

    public init(urlString: String,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage) {
                
        self.urlString = urlString
        self.placeholder = placeholder
        self.image = image
        self.imageLoader = ImageLoader(urlString: urlString)
    }

    @ViewBuilder private var imageContent: some View {
        if let data = imageData {
            data
        } else {
            placeholder()
        }
    }

    public var body: some View {
        imageContent
            .onReceive(imageLoader.$image) { imageData in
                self.imageData = imageData
            }
    }
}
