//
//  APIManager.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class ApiManager: NSObject {
    
    public static let apiKey = "a215b74cd4d371752b0065951c1d1976"
    
    public static let url_master = "https://api.themoviedb.org/3"
    public static let url_media = "https://media.themoviedb.org/t/p/w440_and_h660_face"
    public static let url_youtube_thumbnail = "https://img.youtube.com/vi/{youtube_video_id}/hqdefault.jpg"
    
    let nowPlayingUrl = "/movie/now_playing"
    let popularMovieUrl = "/movie/popular"
    let upcomingMovieUrl = "/movie/upcoming"
    let detailMovieUrl = "/movie/"
    let movieImagesUrl = "/movie/{movie_id}/images"
    let movieVideosUrl = "/movie/{movie_id}/videos"
    let movieReviewsUrl = "/movie/{movie_id}/reviews"
    let movieProvidersUrl = "/movie/{movie_id}/watch/providers"
    
    static let instance = ApiManager()
    let manager: APISessionManager
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60*8
        manager = APISessionManager(configuration: configuration)
        super.init()
    }
    
    func getMovieList(category: HomeMovieCategory, page: Int) -> Observable<[MovieItemModel]> {
        var url = ApiManager.url_master
        switch category {
        case .nowPlaying:
            url += nowPlayingUrl
        case .popular:
            url += popularMovieUrl
        case .upcoming:
            url += upcomingMovieUrl
        }
        let request = manager.request( url, method: .get, parameters: ["page":page], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [MovieItemModel] in
                if response.page >= 1 {
                    var list = [MovieItemModel]()
                    for data in response.results {
                        let model = MovieItemModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[MovieItemModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getMovieDetail(movieId: String) -> Observable<DetailMovieModel> {
        var url = ApiManager.url_master + detailMovieUrl + String(movieId)
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> DetailMovieModel in
                if response.detailResponse.exists() {
                    let detail = DetailMovieModel(fromJson: response.detailResponse)
                    return detail
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<DetailMovieModel> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getMovieImageList(movieId: String) -> Observable<[MovieImageModel]> {
        var url = ApiManager.url_master + movieImagesUrl
        url = url.replacingOccurrences(of: "{movie_id}", with: movieId)
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [MovieImageModel] in
                if response.results.exists() {
                    var list = [MovieImageModel]()
                    for data in response.results {
                        let model = MovieImageModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[MovieImageModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getMovieVideoList(movieId: String) -> Observable<[MovieVideoItemModel]> {
        var url = ApiManager.url_master + movieVideosUrl
        url = url.replacingOccurrences(of: "{movie_id}", with: movieId)
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [MovieVideoItemModel] in
                if response.results.exists() {
                    var list = [MovieVideoItemModel]()
                    for data in response.results {
                        let model = MovieVideoItemModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[MovieVideoItemModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getMovieReviewList(movieId: String) -> Observable<[MovieReviewModel]> {
        var url = ApiManager.url_master + movieReviewsUrl
        url = url.replacingOccurrences(of: "{movie_id}", with: movieId)
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [MovieReviewModel] in
                if response.page >= 1 {
                    var list = [MovieReviewModel]()
                    for data in response.results {
                        let model = MovieReviewModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[MovieReviewModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getMovieProviderList(movieId: String) -> Observable<MovieWatchProviderModel> {
        var url = ApiManager.url_master + movieProvidersUrl
        url = url.replacingOccurrences(of: "{movie_id}", with: movieId)
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> MovieWatchProviderModel in
                if response.results.exists() {
                    let resultData = MovieWatchProviderModel(fromJson: response.results)
                    return resultData
                }
                throw errorWithCode(code: .GlobalError(code: response.status_code, reason: response.status_message))
        }
        
        return requests.catchError({ (errorType) -> Observable<MovieWatchProviderModel> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
}

extension Observable {
    func mapJSONResponse() -> Observable<APIResponse> {
        return map { (item: Element) -> APIResponse in
            guard let json = item as? JSON else {
                return APIResponse(page: 0, results: [JSON()], total_pages: 0, total_results: 0, detailResponse: JSON(), status_code: -1, status_message: "Cannot convert JSON", success: false)
            }
            var page = 0;
            var results = json;
            var totalPages = 0;
            var totalResults = 0;
            var responseDetail = json;
            var statusCode = 0;
            var statusMessage = "";
            var success = true;
            
            if json["page"].exists(){ // Default format list
                page = json["page"].intValue
                
                if json["results"].exists(){
                    results = json["results"]
                }
                if json["total_pages"].exists(){
                    totalPages = json["total_pages"].intValue
                }
                if json["total_results"].exists(){
                    totalResults = json["total_results"].intValue
                }
            }
            else if json["backdrops"].exists() { // Movie backdrops images
                results = json["backdrops"]
            }
            else if json["results"].exists() { // Movie Videos (Trailer)
                results = json["results"]
                
                if json["total_pages"].exists(){
                    totalPages = json["total_pages"].intValue
                }
                if json["total_results"].exists(){
                    totalResults = json["total_results"].intValue
                }
            }
            else if json["id"].exists() { // Movie Detail
                responseDetail = json
            }
            else { // Error response default format
                if json["status_code"].exists(){
                    statusCode = json["status_code"].intValue
                }
                if json["status_message"].exists(){
                    statusMessage = json["status_message"].stringValue
                }
                if json["success"].exists(){
                    success = json["success"].boolValue
                }
            }
            //print("response = \(json)")
            return APIResponse(page: page, results: results, total_pages: totalPages, total_results: totalResults, detailResponse: responseDetail, status_code: statusCode, status_message: statusMessage, success: success)
            //return APIResponse(code: code, message: message, result: result)
        }
    }
}

struct APIResponse {
    var page: Int
    var results: JSON
    var total_pages: Int
    var total_results: Int
    
    var detailResponse: JSON
    
    var status_code: Int
    var status_message: String
    var success: Bool
    
    init(page: Int, results: JSON, total_pages: Int, total_results: Int, detailResponse: JSON, status_code: Int, status_message: String, success: Bool) {
        self.page = page
        self.results = results
        self.total_pages = total_pages
        self.total_results = total_results
        
        self.detailResponse = detailResponse
        
        self.status_code = status_code
        self.status_message = status_message
        self.success = success
    }
}

class APISessionManager: Session {
    
    override func request(_ convertible: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil, requestModifier: Session.RequestModifier? = nil) -> DataRequest {
        
    //override func request(_ convertible: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil) -> DataRequest {
        
        print("CONVERTIBLE URL ",convertible)
        var overridedParameters = [String : AnyObject]()
        print("ovverided parameters = \(overridedParameters)")
        if let parameters = parameters {
            overridedParameters = parameters as [String : AnyObject]
        }
        
        var overridedHeaders = HTTPHeaders.init()
        overridedHeaders["Content-Type"] = "application/json"
        overridedHeaders["accept"] = "application/json"
        overridedHeaders["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMjE1Yjc0Y2Q0ZDM3MTc1MmIwMDY1OTUxYzFkMTk3NiIsIm5iZiI6MTcyNDgxODU0Mi44OTcyMjQsInN1YiI6IjY2Y2U4NmQxODhhZDVhYWM1NWJkN2Q3MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9Y7LvZKK_0HEmU-vV-jjCcQPYvC1_DYoaf_m9SUCVtI"
        
        if let headers = headers {
            for (key, value) in headers.dictionary {
                overridedHeaders[key] = value
            }
        }
        
        #if DEBUG
        print("param: ",overridedParameters)
        print("header: ",overridedHeaders)
        #endif
        
        return super.request(convertible, method: method, parameters: overridedParameters, encoding: encoding, headers: overridedHeaders)
    }
}

extension DataRequest{
    
    func rx_JSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<JSON> {
        let observable = Observable<JSON>.create { observer in
            print("Method : ",self.request?.httpMethod)
            print("Url Request : ",self.request?.url)
            print("Body Request : ",self.request?.httpBody)
            if let method = self.request?.httpMethod, let urlString = self.request?.url {
                print("[\(method)] \(urlString)")
                if let body = self.request?.httpBody {
                    print("request http body = ",NSString(data: body, encoding: String.Encoding.utf8.rawValue) as Any)
                }
            }
            self.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let value = response.value {
                            let json = JSON(value)
                            print("RESPONSE JSON ",json)
                            if let error = json.error {
                                observer.onError(error)
                            } else {
                                observer.onNext(json)
                                observer.onCompleted()
                            }
                        }
                    } catch {
                        if let error = response.error {
                            print("Error while decoding response: \(error.localizedDescription) from: \(String(data: data, encoding: .utf8))")
                            observer.onError(error)
                        } else {
                            observer.onError(errorWithCode(code: .UnknownError))
                        }
                    }
                case .failure(let error):
                    // Handle as previously error
                    observer.onError(error)
                }
            }
            return Disposables.create {
                self.cancel()
            }
        }
        return Observable.deferred { return observable }
    }
}
