//
//  RequestBuilder.swift
//  CharactersApp
//
//  Created by Esraa Gomaa on 10/20/24.
//

import Foundation
import Alamofire
import Combine

public protocol RequestBuilder: URLRequestConvertible {
    var mainURL: String { get }
    var parameters: Parameters? { get }
    var path: String { get }
    var method: HTTPMethod { get }
   // var headers: HTTPHeaders { get }
    var url: URL { get }
    var encoding: EncodingType { get }
}

extension RequestBuilder {
    
    public var mainURL: String {
        if (AppConstants.host.contains("http")) {
            return "\(AppConstants.host)"
        } else {
            return "https://\(AppConstants.host)"
        }
    }
    
//    public var headers: HTTPHeaders {
//        var headers = URLSessionConfiguration.default.headers
//        
//        //Headers default values
//        headers.add(name: "Content-Type", value: "application/json")
//         
//        return headers
//    }

    public var url: URL {
        var url = URL(string: mainURL)!
        url.appendPathComponent(path)
        return url
    }
    
    public var encoding: EncodingType {
        switch method {
        case .get, .put:
            return .query
        default:
            return .body
        }
    }

    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        if encoding == .query {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters?.toURLQueryItems()

            if let urlWithQuery = components?.url?.absoluteString.decodeUrl(),
               let url = URL(string: urlWithQuery) {
                urlRequest = URLRequest(url: url)
            } else if let urlWithQuery = components?.url?.absoluteString.encodeUrl(),
                      let url = URL(string: urlWithQuery) {
                urlRequest = URLRequest(url: url)
            } else {
                throw APIError.invalidURL
            }
        } else {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        urlRequest.httpMethod = method.rawValue
      //  urlRequest.allHTTPHeaderFields = headers.dictionary
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        return urlRequest
    }
    
    
    private func printURL() {
        do{
            try debugPrint(asURLRequest())
        } catch{} //ignore
    }
    
    public func fetch<T: Decodable>() -> AnyPublisher<T?, APIError> {    
        printURL()
        return SessionManager.shared
            .manager!
            .request(self)
            .publishData()
            .tryMap { result in
                if let data = result.value {
                    //printData(data)
                    return data
                }
                throw APIError.unknown
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .tryMap { dataResponse in
                return dataResponse
            }
            .mapError { error in
                if let error = error as? DecodingError {
                    printDecodingErrors(error)
                    return APIError.decoding(message:  error.localizedDescription)
                }
                else if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(message: error.localizedDescription, statusCode: nil)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func printDecodingErrors(_ error: DecodingError) {
        print("DECODING ERROR! \(error)")
        
        var errorMessage = ""
        switch error {
        case .typeMismatch(let type, let context):
            errorMessage = "type mismatch for type \(type) in JSON: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            errorMessage = "could not find type \(type) in JSON: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            errorMessage = "could not find key \(key) in JSON: \(context.debugDescription)"
        case .dataCorrupted(let context):
            errorMessage = "data found to be corrupted in JSON: \(context.debugDescription)"
        default:
            errorMessage = "ERROR: \(error.localizedDescription)"
        }
        print(errorMessage)
    }
  
}

public enum EncodingType {
    case query
    case body
}

extension Dictionary where Key == String, Value == Any {
    func toURLQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        for (key, value) in self {
            if let stringValue = value as? String {
                queryItems.append(URLQueryItem(name: key, value: stringValue))
            } else if let intValue = value as? Int {
                queryItems.append(URLQueryItem(name: key, value: String(intValue)))
            }
        }
        return queryItems
    }
}

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: "%25", with: "%") ?? ""
    }
    
    func decodeUrl() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
