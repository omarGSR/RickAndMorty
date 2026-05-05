//
//  AlamofireClient.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/2026.
//

import Alamofire
import Foundation

final class AlamofireAPIClient: APIClient {
    
    private var environment: EnvironmentServer
    let monitor: NetworkMonitoring
    
    let session: Session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest =  RequestTimeout.default.value
        configuration.timeoutIntervalForResource =  RequestTimeout.long.value
        configuration.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let trustManager = ServerTrustManager(
            evaluators: [
                "rickandmortyapi.com": DisabledTrustEvaluator() // Only DEV
            ]
        )
        
        let interceptor = AuthInterceptor()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            serverTrustManager: trustManager
        )
    }()
    
    init(environment: EnvironmentServer,
         monitor: NetworkMonitoring) {
        
        self.environment = environment
        self.monitor = monitor
    }
    
    func setEnvironment(_ environment: EnvironmentServer) {
        self.environment = environment
    }
    
    func hasInternetConnection() -> Bool {
        monitor.isConnected
    }
    
    func request<T: Decodable & Sendable> (_ endpoint: Endpoint) async throws -> T {
        
        #if DEBUG
            // Note: NWPath is having few issues in simulator, for now we will avoid this comprobation in order to check turn ON/OFF Wi-fi access retry buttons
        #else
        guard hasInternetConnection() else {
            throw APIError.notInternet
        }
        #endif
     
        // uncomment this to check spineers timers, and updates
        //  try? await Task.sleep(for: .seconds(1))
                
        let url: URL = try endpoint.makeURL(for: environment.baseURL)
        let timeout: TimeInterval = endpoint.timeout.value
        let maxRetries: Int = Int(endpoint.retries)
        let method: HTTPMethod = endpoint.method
        
        let response = await session
            .request(url,
                     method: endpoint.method,
                     parameters: endpoint.body,
                     encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                     requestModifier: {
                $0.timeoutInterval = timeout
                if maxRetries > 0 {
                    $0.setValue("\(maxRetries)", forHTTPHeaderField: "X-Max-Retries")
                }
            })
            .validate()
            .serializingDecodable(T.self)
            .response
        
        if let error = response.error {
            
            if let afError = error.asAFError {
                switch afError {
                case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
                    if code == 429 {
                        throw APIError.tooManyRequests
                    }

                default:
                    break
                }
            }
            
            if let urlError = error.underlyingError as? URLError {
                
                if urlError.code == .notConnectedToInternet {
                
                    throw APIError.notInternet
                }
            }
        
            throw error
        }
        
        guard let value = response.value else {
            throw APIError.emptyResponse
        }
        
        return value
    }
    
    private func handlerParseError(_ error: Error) throws {
        
        if let afError = error.asAFError {
            switch afError {
            case .responseValidationFailed(reason: .unacceptableStatusCode(let code)):
                if code == 429 {
                    throw APIError.tooManyRequests
                }

            default:
                break
            }

            if let urlError = afError.underlyingError as? URLError {
                
                switch urlError.code {
                case .notConnectedToInternet:
                    throw APIError.notInternet
                default:
                    throw error
                    
                }
            }
        }
    
        throw error
        
    }
}
