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
        
        guard hasInternetConnection() else {
            throw APIError.notInternet
        }
                
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
        
        if let error = response.error { throw error }
        
        guard let value = response.value else {
            throw APIError.emptyResponse
        }
        
        return value
    }
}
