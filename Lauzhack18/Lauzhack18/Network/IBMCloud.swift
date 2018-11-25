//
//  IBMCloud.swift
//  Lauzhack18
//
//  Created by Lionel Pellier on 24/11/2018.
//  Copyright © 2018 Lionel Pellier. All rights reserved.
//

import Foundation
import Moya
import UIKit

public enum IBMCloud{
    static private let APIKey = "3TxYRkyOu3dECm7bYGzNZRm-ypWIrpON_SPA-Rv0sV85"
    
    case image(UIImage)
}

extension IBMCloud: TargetType{
    public var baseURL: URL {
        return URL(string: "https://gateway.watsonplatform.net/visual-recognition/api")!
    }
    
    public var path: String {
        switch self {
        case .image: return "/v3/classify?version=2018-03-19"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .image: return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self{
        case .image(let image):
            let imageData = image.pngData()!
            debugPrint(imageData)
            let imageAsString = String(data: imageData, encoding: .utf8) as String!
            return .requestParameters(parameters: ["image" : imageAsString!, "apikey": IBMCloud.APIKey], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
