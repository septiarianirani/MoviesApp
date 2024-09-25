//
//  MovieImageModel.swift
//  MoviesApp
//
//  Created by Mac on 17/09/24.
//

import Foundation
import SwiftyJSON

class MovieImageModel : NSObject, NSCoding{

    var aspect_ratio : Int!
    var height : Int!
    var iso_639_1 : String!
    var file_path : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        aspect_ratio = json["aspect_ratio"].intValue
        height = json["height"].intValue
        iso_639_1 = json["iso_639_1"].stringValue
        file_path = json["file_path"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aspect_ratio != nil{
            dictionary["aspect_ratio"] = aspect_ratio
        }
        if height != nil{
            dictionary["height"] = height
        }
        if iso_639_1 != nil{
            dictionary["iso_639_1"] = iso_639_1
        }
        if file_path != nil{
            dictionary["file_path"] = file_path
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        aspect_ratio = aDecoder.decodeObject(forKey: "aspect_ratio") as? Int
        height = aDecoder.decodeObject(forKey: "height") as? Int
        iso_639_1 = aDecoder.decodeObject(forKey: "iso_639_1") as? String
        file_path = aDecoder.decodeObject(forKey: "file_path") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if aspect_ratio != nil{
            aCoder.encode(aspect_ratio, forKey: "aspect_ratio")
        }
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if iso_639_1 != nil{
            aCoder.encode(iso_639_1, forKey: "iso_639_1")
        }
        if file_path != nil{
            aCoder.encode(file_path, forKey: "file_path")
        }
    }

}
