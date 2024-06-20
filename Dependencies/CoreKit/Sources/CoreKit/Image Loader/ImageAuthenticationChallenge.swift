//
//  ImageAuthenticationChallenge.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import Kingfisher

public final class ImageAuthenticationChallenge: AuthenticationChallengeResponsible {
    
    public func downloader(_ downloader: ImageDownloader, 
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
}
