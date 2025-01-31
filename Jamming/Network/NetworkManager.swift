//
//  NetworkManager.swift
//  Jamming
//
//  Created by Claire on 1/24/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func callRequest<T: Decodable>(api: TMDBRequest,
                                   completionHandler: @escaping (T) -> Void,
                                   failureHandler: @escaping (_ code: Int?, _ message: String) -> Void) {
        
        AF.request(api.endPoint, method: api.method, headers: api.header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                    if let responseCode = error.responseCode {
                        let message = switch responseCode {
                        case 400..<500 : "Client Error"
                        case 500..<510 : "Server Error"
                        default : "Unknown Error"
                        }
                        failureHandler(responseCode, message)
                    } else {
                        failureHandler(-1, "No ResponseCode")
                    }
                }
            }
    }
    
}
