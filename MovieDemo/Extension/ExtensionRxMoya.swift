//
//  ExtensionRxMoya.swift
//  Esports
//
//  Created by Daniel on 2020/3/3.
//  Copyright © 2020 ST_Ray.Lin. All rights reserved.
//

import Moya
import RxSwift

protocol HttpStatusCode {
    var statusCode: Int? { get set }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapIncludeStatusCode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
        return flatMap { .just(try $0.mapIncludeStatusCode(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}

extension Response {
    /// Maps data received from the signal into a Decodable object.
    ///
    /// - parameter atKeyPath: Optional key path at which to parse object.
    /// - parameter using: A `JSONDecoder` instance which is used to decode data to an object.
    func mapIncludeStatusCode<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) throws -> D {
        let serializeToData: (Any) throws -> Data? = { (jsonObject) in
            guard JSONSerialization.isValidJSONObject(jsonObject) else {
                return nil
            }
            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                print("Decode error:\nurl: \(String(describing: self.response?.url?.absoluteString))\ndescription: \(MoyaError.jsonMapping(self))")
                throw MoyaError.jsonMapping(self)
            }
        }
        let jsonData: Data
        keyPathCheck: if let keyPath = keyPath {
            guard let jsonObject = (try mapJSON(failsOnEmptyData: failsOnEmptyData) as? NSDictionary)?.value(forKeyPath: keyPath) else {
                if failsOnEmptyData {
                    print("Decode error:\nurl: \(String(describing: self.response?.url?.absoluteString))\ndescription: \(MoyaError.jsonMapping(self))")
                    throw MoyaError.jsonMapping(self)
                } else {
                    jsonData = data
                    break keyPathCheck
                }
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    print("Decode error:\nurl: \(String(describing: self.response?.url?.absoluteString))\ndescription: \(MoyaError.jsonMapping(self))")
                    throw MoyaError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(D.self, from: wrappedJsonData)
                } catch let error {
                    print("Decode error:\nurl: \(String(describing: self.response?.url?.absoluteString))\ndescription: \(MoyaError.objectMapping(error, self))")
                    throw MoyaError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            if jsonData.count < 1 && !failsOnEmptyData {
                if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONObjectData) {
                    return emptyDecodableValue
                } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(D.self, from: emptyJSONArrayData) {
                    return emptyDecodableValue
                }
            }
            let res = try decoder.decode(D.self, from: jsonData)
            if var res = res as? HttpStatusCode { res.statusCode = self.statusCode }
            return res
        } catch let error {
            print("Decode error:\nurl: \(String(describing: self.response?.url?.absoluteString))\ndescription: \(MoyaError.objectMapping(error, self))")
            throw MoyaError.objectMapping(error, self)
        }
    }
}
