//
//  ImageLoader.swift
//
//
//  Created by Sourabh Bhardwaj on 14/06/24.
//

import SwiftUI
import Combine
import Kingfisher

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func load(from urlString: String) {
        if let url = URL(string: urlString), url.isFileURL {
            loadLocalImage(from: url)
        } 
        else {
            loadRemoteImage(from: urlString)
        }
    }
    
    private func loadLocalImage(from url: URL) {
        if let uiImage = UIImage(contentsOfFile: url.path) {
            self.image = uiImage
        } 
        else {
            self.image = nil
        }
    }
    
    private func loadRemoteImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        
        // Use Kingfisher to download the image
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.image = value.image
                }
            case .failure:
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}
