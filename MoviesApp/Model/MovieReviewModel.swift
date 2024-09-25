//
//  MovieReviewModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import SwiftyJSON

class MovieReviewModel : NSObject, NSCoding{

    var author : String!
    var author_details : ReviewAuthorModel!
    var content : String!
    var created_at : String!
    var updated_at : String!
    var id : String!
    var url : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        author = json["author"].stringValue
        let author_detailsJson = json["author_details"]
        if !author_detailsJson.isEmpty{
            author_details = ReviewAuthorModel(fromJson: author_detailsJson)
        }
        content = json["content"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        id = json["id"].stringValue
        url = json["url"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if author != nil{
            dictionary["author"] = author
        }
        if author_details != nil{
            dictionary["author_details"] = author_details.toDictionary()
        }
        if content != nil{
            dictionary["content"] = content
        }
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        if id != nil{
            dictionary["id"] = id
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        author = aDecoder.decodeObject(forKey: "author") as? String
        author_details = aDecoder.decodeObject(forKey: "author_details") as? ReviewAuthorModel
        content = aDecoder.decodeObject(forKey: "content") as? String
        created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if author != nil{
            aCoder.encode(author, forKey: "author")
        }
        if author_details != nil{
            aCoder.encode(author_details, forKey: "author_details")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if created_at != nil{
            aCoder.encode(created_at, forKey: "created_at")
        }
        if updated_at != nil{
            aCoder.encode(updated_at, forKey: "updated_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
    }

}
