//
//  DefaultURLSessionDelegate.swift
//
//
//  Created by Sourabh Bhardwaj on 20/06/24.
//

import Foundation

public final class DefaultSessionDelegate: NSObject, URLSessionDelegate {
    
    public func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("DefaultSessionDelegate:: didReceive challenge called")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }
        else {
            print("DefaultSessionDelegate:: handling .performDefaultHandling")
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
