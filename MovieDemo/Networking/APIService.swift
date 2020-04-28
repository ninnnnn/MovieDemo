//
//  APIService.swift
//  Moya+Rx
//
//  Created by Daniel on 2020/2/3.
//  Copyright © 2020 Daniel. All rights reserved.
//

import Moya
import RxSwift

enum DynamicObject: Codable {
    case string(String)
    case int(Int)
    case array([String])
    case dict([String:String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
            return
        }
        if let int = try? container.decode(Int.self) {
            self = .int(int)
            return
        }
        if let array = try? container.decode([String].self) {
            self = .array(array)
            return
        }
        if let dict = try? container.decode([String:String].self) {
            self = .dict(dict)
            return
        }
        throw DecodingError.typeMismatch(DynamicObject.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Exception Type For DynamicObject"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string): try container.encode(string)
        case .int(let int): try container.encode(int)
        case .array(let array): try container.encode(array)
        case .dict(let dict): try container.encode(dict)
        }
    }
}

class BaseResponseData<T: Codable>: Codable, HttpStatusCode {
    var statusCode: Int?
    
    let data: T?
    let error: APIResponseError?
    let traceId: String?
}

class APIResponseError: Codable, Error {
    let code: String
    let message: String
    let details: DynamicObject?
    
    init(error: Error) {
        self.code = String(error._code)
        self.message = "发生异常错误，请联系客服"
        self.details = nil
    }
}

class BaseResponseData_Gaming<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
}

final class APIService {
    static let shared = APIService()
    
    private init() {}
    private var provider = MoyaProvider<MultiTarget>()
    
    func request<Request: ApiTargetType>(_ request: Request) -> Single<Request.ResponseDataType> {
        let target = MultiTarget.init(request)
//        provider = MoyaProvider<MultiTarget>(session: customSession(request: request), plugins: [EsportsPlugin()])
        if let keyPath = request.dataKeyPath {
            return provider.rx.request(target).mapIncludeStatusCode(Request.ResponseDataType.self, atKeyPath: keyPath)
        } else {
            return provider.rx.request(target).mapIncludeStatusCode(Request.ResponseDataType.self)
        }
    }
    
    func request_Gaming<Request: ApiTargetType>(_ request: Request) -> Single<Request.ResponseDataType> {
        let target = MultiTarget.init(request)
//        provider = MoyaProvider<MultiTarget>(session: customSession(request: request), plugins: [EsportsPlugin()])
        if let keyPath = request.dataKeyPath {
            return provider.rx.request(target).map(Request.ResponseDataType.self, atKeyPath: keyPath)
        } else {
            return provider.rx.request(target).map(Request.ResponseDataType.self)
        }
    }
    
    private func customSession<T: ApiTargetType>(request: T) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = request.timeout
        configuration.timeoutIntervalForResource = request.timeout
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
}

