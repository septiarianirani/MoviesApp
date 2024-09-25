//
//  Response.swift
//  MoviesApp
//
//  Created by Rani on 28/08/24.
//

import Foundation

public  struct Response<T : Codable>:Codable {
    public let page : Int?
    public let results : T?
    public let total_pages : Int?
    public let total_results : Int?
    
//    public var status_message: String?
//    public var status_code: Int?
//    public var success: Bool?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        //results = try container.decode([T].self, forKey: .results)
        total_pages = try container.decode(Int.self, forKey: .total_pages)
        total_results = try container.decode(Int.self, forKey: .total_results)
        
        if let data = try? container.decode(T.self, forKey: .results){
            results = data
        } else {
            results = nil
        }
        
//        status_message = try container.decode(String.self, forKey: .status_message)
//        status_code = try container.decode(Int.self, forKey: .status_code)
//        success = try container.decode(Bool.self, forKey: .success)
    }
}
