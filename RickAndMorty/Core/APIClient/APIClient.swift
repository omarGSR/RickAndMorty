//
//  APIClient.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/2/26.
//

protocol APIClient {
    func request<T: Decodable & Sendable> (_ endpoint: Endpoint) async throws -> T
}

