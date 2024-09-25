//
//  DetailMovieModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import SwiftyJSON

class DetailMovieModel : NSObject, NSCoding{

    var adult : Bool!
    var backdrop_path : String!
    var genres: [MovieGenreModel]!
    var id : Int!
    var original_title : String!
    var overview : String!
    var popularity : Double!
    var poster_path : String!
    var release_date : String!
    var runtime : Int!
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
        backdrop_path = json["backdrop_path"].stringValue
        genres = [MovieGenreModel]()
        let genresListArray = json["genres"].arrayValue
        for genresListJson in genresListArray{
            let value = MovieGenreModel(fromJson: genresListJson)
            genres.append(value)
        }
        id = json["id"].intValue
        original_title = json["original_title"].stringValue
        overview = json["overview"].stringValue
        popularity = json["popularity"].doubleValue
        poster_path = json["poster_path"].stringValue
        release_date = json["release_date"].stringValue
        runtime = json["runtime"].intValue
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
        if backdrop_path != nil{
            dictionary["backdrop_path"] = backdrop_path
        }
        if genres != nil{
            var dictionaryElements = [[String:Any]]()
            for genresListElement in genres {
                dictionaryElements.append(genresListElement.toDictionary())
            }
            dictionary["genres"] = dictionaryElements
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
        if runtime != nil{
            dictionary["runtime"] = runtime
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
        backdrop_path = aDecoder.decodeObject(forKey: "backdrop_path") as? String
        genres = aDecoder.decodeObject(forKey: "genres") as? [MovieGenreModel]
        id = aDecoder.decodeObject(forKey: "id") as? Int
        original_title = aDecoder.decodeObject(forKey: "original_title") as? String
        overview = aDecoder.decodeObject(forKey: "overview") as? String
        popularity = aDecoder.decodeObject(forKey: "popularity") as? Double
        poster_path = aDecoder.decodeObject(forKey: "poster_path") as? String
        release_date = aDecoder.decodeObject(forKey: "release_date") as? String
        runtime = aDecoder.decodeObject(forKey: "runtime") as? Int
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
        if backdrop_path != nil{
            aCoder.encode(backdrop_path, forKey: "backdrop_path")
        }
        if genres != nil{
            aCoder.encode(genres, forKey: "genres")
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
        if runtime != nil{
            aCoder.encode(runtime, forKey: "runtime")
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
