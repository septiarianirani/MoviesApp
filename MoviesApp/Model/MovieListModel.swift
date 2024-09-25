//
//  MovieListModel.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import Foundation
import SwiftyJSON

class MovieItemModel : NSObject, NSCoding{

    var adult : Bool!
    var id : Int!
    var original_title : String!
    var overview : String!
    var popularity : Double!
    var poster_path : String!
    var release_date : String!
    var title : String!
    var video : Bool!
    var vote_count : Int!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adult = json["adult"].boolValue
        id = json["id"].intValue
        original_title = json["original_title"].stringValue
        overview = json["overview"].stringValue
        popularity = json["popularity"].doubleValue
        poster_path = json["poster_path"].stringValue
        release_date = json["release_date"].stringValue
        title = json["title"].stringValue
        video = json["video"].boolValue
        vote_count = json["vote_count"].intValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adult != nil{
            dictionary["adult"] = adult
        }
        if id != nil{
            dictionary["id"] = id
        }
        if original_title != nil{
            dictionary["original_title"] = original_title
        }
        if overview != nil{
            dictionary["overview"] = overview
        }
        if popularity != nil{
            dictionary["popularity"] = popularity
        }
        if poster_path != nil{
            dictionary["poster_path"] = poster_path
        }
        if release_date != nil{
            dictionary["release_date"] = release_date
        }
        if title != nil{
            dictionary["title"] = title
        }
        if video != nil{
            dictionary["video"] = video
        }
        if vote_count != nil{
            dictionary["vote_count"] = vote_count
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        adult = aDecoder.decodeObject(forKey: "adult") as? Bool
        id = aDecoder.decodeObject(forKey: "id") as? Int
        original_title = aDecoder.decodeObject(forKey: "original_title") as? String
        overview = aDecoder.decodeObject(forKey: "overview") as? String
        popularity = aDecoder.decodeObject(forKey: "popularity") as? Double
        poster_path = aDecoder.decodeObject(forKey: "poster_path") as? String
        release_date = aDecoder.decodeObject(forKey: "release_date") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        video = aDecoder.decodeObject(forKey: "video") as? Bool
        vote_count = aDecoder.decodeObject(forKey: "vote_count") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if adult != nil{
            aCoder.encode(adult, forKey: "adult")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if original_title != nil{
            aCoder.encode(original_title, forKey: "original_title")
        }
        if overview != nil{
            aCoder.encode(overview, forKey: "overview")
        }
        if popularity != nil{
            aCoder.encode(popularity, forKey: "popularity")
        }
        if poster_path != nil{
            aCoder.encode(poster_path, forKey: "poster_path")
        }
        if release_date != nil{
            aCoder.encode(release_date, forKey: "release_date")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if video != nil{
            aCoder.encode(video, forKey: "video")
        }
        if vote_count != nil{
            aCoder.encode(vote_count, forKey: "vote_count")
        }
    }

}
