//
//  DetailMovieViewModel.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class DetailMovieViewModel: NSObject {
    
    var movieId: Int = 0
    var detailMovie: DetailMovieModel?
    var listImages = [MovieImageModel]()
    var listVideos = [MovieVideoItemModel]() {
        didSet {
            self.listVideos = self.listVideos.filter({ video in
                return (video.typeVideo.lowercased().contains("teaser") && video.site.lowercased().contains("youtube")) || (video.typeVideo.lowercased().contains("trailer") && video.site.lowercased().contains("youtube"))
            })
        }
    }
    var listReviews = [MovieReviewModel]()
    var watchProviders: MovieWatchProviderModel?
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let detailPublished: PublishSubject<DetailMovieModel>  = PublishSubject()
    public let imagesPublished: PublishSubject<[MovieImageModel]>  = PublishSubject()
    public let videosPublished: PublishSubject<[MovieVideoItemModel]>  = PublishSubject()
    public let reviewsPublished: PublishSubject<[MovieReviewModel]>  = PublishSubject()
    public let watchProvidersPublished: PublishSubject<MovieWatchProviderModel>  = PublishSubject()
    public let error : PublishSubject<NSError> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestDetailMovie(){
        self.loading.onNext(true)
        ApiManager.instance.getMovieDetail(movieId: String(self.movieId))
            .do( onNext : { model in
                self.loading.onNext(false)
                self.detailMovie = model
                self.detailPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
    
    public func requestImageList() {
        self.loading.onNext(true)
        ApiManager.instance.getMovieImageList(movieId: String(self.movieId))
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listImages = model
                self.imagesPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
    
    public func requestVideoList() {
        self.loading.onNext(true)
        ApiManager.instance.getMovieVideoList(movieId: String(self.movieId))
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listVideos = model
                self.videosPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
    
    public func requestReviewList() {
        self.loading.onNext(true)
        ApiManager.instance.getMovieReviewList(movieId: String(self.movieId))
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listReviews = model
                self.reviewsPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
    
    public func requestMovieWatchProvider(){
        self.loading.onNext(true)
        ApiManager.instance.getMovieProviderList(movieId: String(self.movieId))
            .do( onNext : { model in
                self.loading.onNext(false)
                self.watchProviders = model
                self.watchProvidersPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
}
