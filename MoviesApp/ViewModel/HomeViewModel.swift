//
//  HomeViewModel.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class HomeViewModel: NSObject {
    
    var listUpcoming = [MovieItemModel]()
    var listNowPlaying = [MovieItemModel]()
    var listPopular = [MovieItemModel]()
    var popularPage: Int = 1
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let upcomingPublished: PublishSubject<[MovieItemModel]>  = PublishSubject()
    public let nowPlayingPublished: PublishSubject<[MovieItemModel]>  = PublishSubject()
    public let popularPublished: PublishSubject<[MovieItemModel]>  = PublishSubject()
    public let error : PublishSubject<NSError> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestDataMovies(category: HomeMovieCategory){
        self.loading.onNext(true)
        var page = 1
        if category == .popular {
            page = popularPage
        }
        ApiManager.instance.getMovieList(category: category, page: page)
            .do( onNext : { model in
                self.loading.onNext(false)
                switch category {
                case .nowPlaying:
                    self.listNowPlaying = model
                    self.nowPlayingPublished.onNext(model)
                case .popular:
                    self.listPopular = model
                    self.popularPublished.onNext(model)
                case .upcoming:
                    self.listUpcoming = model
                    self.popularPage += 1
                    self.upcomingPublished.onNext(model)
                }
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
