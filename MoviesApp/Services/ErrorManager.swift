//
//  ErrorManager.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import Foundation

class errorManager: NSObject {

}
let ErrorObjectDomain = "MovieAppErrorDomain"

enum WhiteLabelErrorCode {
    case UnknownError
    case JSONParserError
    case GlobalError(code: Int, reason: String)
}

func errorWithCode(code: WhiteLabelErrorCode) -> NSError {
    switch code {
    case .UnknownError:
        return NSError(domain: ErrorObjectDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
    case .JSONParserError:
        return NSError(domain: ErrorObjectDomain, code: -2, userInfo: [NSLocalizedDescriptionKey: "JSON parser error"])
    case let .GlobalError(code, reason):
        return NSError(domain: ErrorObjectDomain, code: code, userInfo: [NSLocalizedDescriptionKey: reason])
    }
}
