//
//  ImageDownloaderConfiguration.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation
import NetworkKit
import Kingfisher

public class ImageDownloaderConfiguration {
    
    public static func setup() {
        ImageDownloader.default.authenticationChallengeResponder = KFAuthenticationChallengeResponder()
      }

}


final class KFAuthenticationChallengeResponder: AuthenticationChallengeResponsible {
    
    public func downloader(_ downloader: ImageDownloader,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("KFAuthenticationChallenge:: downloader :: didReceive challenge called")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
        else {
            print("KFAuthenticationChallenge:: downloader .performDefaultHandling")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func downloader(_ downloader: ImageDownloader, 
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("KFAuthenticationChallenge:: task :: didReceive challenge called")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
        else {
            print("KFAuthenticationChallenge:: task .performDefaultHandling")
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func handle(_ challenge: URLAuthenticationChallenge,
                completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("KFAuthenticationChallenge:: handle :: didReceive challenge called")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } 
        else {
            print("KFAuthenticationChallenge:: handle .performDefaultHandling")
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
