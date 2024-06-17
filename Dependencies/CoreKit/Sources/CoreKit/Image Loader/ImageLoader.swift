//
//  ImageLoader.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import Foundation
import Kingfisher
import SwiftUI

public class ImageLoader: ObservableObject {
    @Published var image: Image?

    public convenience init(urlString: String) {
        self.init()
        
        guard let url = URL(string: urlString) else {
            print("Invalid url for image download = \(urlString)")
            return
        }
        
        downloadImage(with: url.absoluteString)
    }
    
    func downloadImage(`with` urlString : String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = KF.ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.image = Image(uiImage: value.image).renderingMode(.original)
                }
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}
