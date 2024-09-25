//
//  ResponseErrorModel.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import Foundation

public struct ResponseErrorModel {
    public var status_message: String
    public var status_code: Int
    public var success: Bool
    
    init(status_code: Int, status_message: String, success: Bool) {
        self.status_code = status_code
        self.success = success
        switch status_code {
            case 504:
                self.status_message = "Request Time Out"
            default:
                self.status_message = status_message
        }
    }
}
