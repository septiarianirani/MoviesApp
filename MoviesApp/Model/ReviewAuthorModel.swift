//
//  ReviewAuthorModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import SwiftyJSON

class ReviewAuthorModel : NSObject, NSCoding{

    var name : String!
    var username : String!
    var avatar_path : String!
    var rating : Int!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        username = json["username"].stringValue
        avatar_path = json["avatar_path"].stringValue
        rating = json["rating"].intValue
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
        if username != nil{
            dictionary["username"] = username
        }
        if avatar_path != nil{
            dictionary["avatar_path"] = avatar_path
        }
        if rating != nil{
            dictionary["rating"] = rating
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
        username = aDecoder.decodeObject(forKey: "username") as? String
        avatar_path = aDecoder.decodeObject(forKey: "avatar_path") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
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
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if avatar_path != nil{
            aCoder.encode(avatar_path, forKey: "avatar_path")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
    }

}
