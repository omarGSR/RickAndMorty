//
//  AuthInterceptor.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/26.
//

import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {
    
    // MARK: - Token provider
    
    private var accessToken: String? {
        // getting from Keychain, or UserDefaults encrypted, ..
        return nil
    }
    
    // MARK: - Adapt (headers)
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request: URLRequest = urlRequest
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    // MARK: - Retry
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        if let response = request.response {
            
            if  response.statusCode == 401 {
                completion(.doNotRetry)
                return
            }
            
            #warning("Confirm with BE-team if that its apropiated or is better to remove becouse time delay needs higher or impredictable")
            if response.statusCode == 429, request.retryCount < 2 {
                completion(.retryWithDelay(3))
                return
            }
        }
    
        let maxRetries = Int(request.request?.value(forHTTPHeaderField: "X-Max-Retries") ?? "") ?? 0
        
        if request.retryCount < maxRetries,
           (error as? AFError)?.isSessionTaskError == true {
            completion(.retryWithDelay(1))
            return
        }
        
        completion(.doNotRetry)
    }
}
