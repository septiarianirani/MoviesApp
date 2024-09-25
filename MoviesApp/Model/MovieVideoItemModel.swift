//
//  MovieVideoItemModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import SwiftyJSON

class MovieVideoItemModel : NSObject, NSCoding{

    var name : String!
    var key : String!
    var site : String!
    var size : Int!
    var typeVideo : String!
    var published_at : String!
    var id : String!
    var official : Bool!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        key = json["key"].stringValue
        site = json["site"].stringValue
        size = json["size"].intValue
        typeVideo = json["type"].stringValue
        published_at = json["published_at"].stringValue
        id = json["id"].stringValue
        official = json["official"].boolValue
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
        if key != nil{
            dictionary["key"] = key
        }
        if site != nil{
            dictionary["site"] = site
        }
        if size != nil{
            dictionary["size"] = size
        }
        if typeVideo != nil{
            dictionary["type"] = typeVideo
        }
        if published_at != nil{
            dictionary["published_at"] = published_at
        }
        if id != nil{
            dictionary["id"] = id
        }
        if official != nil{
            dictionary["official"] = official
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
        key = aDecoder.decodeObject(forKey: "key") as? String
        site = aDecoder.decodeObject(forKey: "site") as? String
        size = aDecoder.decodeObject(forKey: "size") as? Int
        typeVideo = aDecoder.decodeObject(forKey: "type") as? String
        published_at = aDecoder.decodeObject(forKey: "published_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        official = aDecoder.decodeObject(forKey: "official") as? Bool
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
        if key != nil{
            aCoder.encode(key, forKey: "key")
        }
        if site != nil{
            aCoder.encode(site, forKey: "site")
        }
        if size != nil{
            aCoder.encode(size, forKey: "size")
        }
        if typeVideo != nil{
            aCoder.encode(typeVideo, forKey: "type")
        }
        if published_at != nil{
            aCoder.encode(published_at, forKey: "published_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if official != nil{
            aCoder.encode(official, forKey: "official")
        }
    }

}
