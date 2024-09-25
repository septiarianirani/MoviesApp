//
//  MovieWatchProviderModel.swift
//  MoviesApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import SwiftyJSON

class MovieWatchProviderModel : NSObject, NSCoding{

    var CA : WatchProviderDetailModel?
    var US : WatchProviderDetailModel?
    var AU : WatchProviderDetailModel?
    var BO : WatchProviderDetailModel?
    var IN : WatchProviderDetailModel?
    var SG : WatchProviderDetailModel?
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let caJson = json["CA"]
        if !caJson.isEmpty{
            CA = WatchProviderDetailModel(fromJson: caJson)
        }
        let usJson = json["US"]
        if !usJson.isEmpty{
            US = WatchProviderDetailModel(fromJson: usJson)
        }
        let auJson = json["AU"]
        if !auJson.isEmpty{
            AU = WatchProviderDetailModel(fromJson: auJson)
        }
        let boJson = json["BO"]
        if !boJson.isEmpty{
            BO = WatchProviderDetailModel(fromJson: boJson)
        }
        let inJson = json["IN"]
        if !inJson.isEmpty{
            IN = WatchProviderDetailModel(fromJson: inJson)
        }
        let sgJson = json["SG"]
        if !sgJson.isEmpty{
            SG = WatchProviderDetailModel(fromJson: sgJson)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if CA != nil{
            dictionary["CA"] = CA?.toDictionary()
        }
        if US != nil{
            dictionary["US"] = US?.toDictionary()
        }
        if AU != nil{
            dictionary["AU"] = AU?.toDictionary()
        }
        if BO != nil{
            dictionary["BO"] = BO?.toDictionary()
        }
        if IN != nil{
            dictionary["IN"] = IN?.toDictionary()
        }
        if SG != nil{
            dictionary["SG"] = SG?.toDictionary()
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        CA = aDecoder.decodeObject(forKey: "CA") as? WatchProviderDetailModel
        US = aDecoder.decodeObject(forKey: "US") as? WatchProviderDetailModel
        AU = aDecoder.decodeObject(forKey: "AU") as? WatchProviderDetailModel
        BO = aDecoder.decodeObject(forKey: "BO") as? WatchProviderDetailModel
        IN = aDecoder.decodeObject(forKey: "IN") as? WatchProviderDetailModel
        SG = aDecoder.decodeObject(forKey: "SG") as? WatchProviderDetailModel
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if CA != nil{
            aCoder.encode(CA, forKey: "CA")
        }
        if US != nil{
            aCoder.encode(US, forKey: "US")
        }
        if AU != nil{
            aCoder.encode(AU, forKey: "AU")
        }
        if BO != nil{
            aCoder.encode(BO, forKey: "BO")
        }
        if IN != nil{
            aCoder.encode(IN, forKey: "IN")
        }
        if SG != nil{
            aCoder.encode(SG, forKey: "SG")
        }
    }

}
