//
//  Authentication.swift
//  Pedibook
//
//  Created by Lionel Pellier on 20/10/2018.
//  Copyright © 2018 Lionel Pellier. All rights reserved.
//

import Foundation
import Moya
import UIKit

public enum ImageAPI{
    static private let clientId = "???"
    static private let clientSecret = "???"
    
    case image(UIImage)    
}

extension ImageAPI: TargetType{
    public var baseURL: URL {
        return URL(string: "http://128.179.140.166:8080")!
    }
    
    public var path: String {
        switch self {
        case .image: return "/helloFromIos"
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
            let imageData = image.pngData()
            //let imageAsString = String(data: imageData!, encoding: String.Encoding.utf8) as String!
            var strBase64 = imageData!.base64EncodedString(options: .init(rawValue: 0))
            /*while(strBase64.last! == "="){
                print("came here")
                strBase64.removeLast()
            }*/
            print(strBase64.last!)
            //debugPrint(strBase64.count % 4)
            //debugPrint(strBase64)
            /*let remainder = strBase64.count % 4
            if remainder > 0 {
                strBase64 = strBase64.padding(toLength: strBase64.count + 4 - remainder, withPad: "=", startingAt: 0)
            }
            debugPrint(strBase64)*/

            //debugPrint(imageAsString!)
            return .requestParameters(parameters: ["image" : strBase64], encoding: JSONEncoding.default)

        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
