//
//  MovieGenreModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import SwiftyJSON

class MovieGenreModel : NSObject, NSCoding{

    var name : String!
    var id : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        id = json["id"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if id != nil{
            dictionary["id"] = id
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
    }

}
