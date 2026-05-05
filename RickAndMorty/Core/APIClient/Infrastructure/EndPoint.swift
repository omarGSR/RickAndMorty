//
//  EndPoint.swift
//  Omar Fazal
//
//  Created by silenGSR on 12/02/26.
//

import Foundation
import Alamofire

enum Endpoint {
    case custom(urlString: String,
                method: HTTPMethod = .get,
                timeout: RequestTimeout = .default,
                retries: Int = 0)
    
    case characters(page: Int)
    case character(id: Int)
    
    var path: String {
        switch self {
        case .custom:
            return ""
        case .characters:
            return "/api/character"
        case .character(let id):
            return "/api/character/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .custom,
                .character:
            return nil
        case .characters(page: let page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
    
    var body: Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .custom(_, let customMethod, _,_):
            return customMethod
        case .characters,
                .character:
            return .get
        }
    }
    
    var retries: Int {
        switch self {
        case .custom(_,_,_, let totalRetries): return totalRetries
        default: return 1
        }
    }
    
    var timeout: RequestTimeout {
        switch self {
        case .custom( _,_, let customTimeout, _): return customTimeout
        default: return .default
        }
    }
    
    func makeURL(for baseURLString: String) throws -> URL {
        
        var components = URLComponents(string: baseURLString)
        components?.path = path
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw EndpointError.invalidURL
        }
        
        return url
    }
}
