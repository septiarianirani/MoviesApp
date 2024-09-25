//
//  WatchProviderDetailModel.swift
//  MoviesApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import SwiftyJSON

class WatchProviderDetailModel : NSObject, NSCoding{

    var link : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        link = json["link"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if link != nil{
            dictionary["link"] = link
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        link = aDecoder.decodeObject(forKey: "link") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
    }

}
