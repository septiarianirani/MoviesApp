//
//  DetailMovieViewController.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import UIKit
import PKHUD
import Toast_Swift
import RxSwift
import RxCocoa
import AlamofireImage
import WebKit

class DetailMovieViewController: UIViewController {

    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var movieRatedView: UIView!
    @IBOutlet var movieGenreLabel: UILabel!
    @IBOutlet var movieOverviewLabel: UILabel!
    @IBOutlet var trailerCollectionView: UICollectionView!
    @IBOutlet var reviewCollectionView: UICollectionView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var watchNowButton: UIButton!
    @IBOutlet var trailerView: UIView!
    @IBOutlet var trailerContentView: UIView!
    @IBOutlet var trailerCloseBtn: UIButton!
    
    var wkWebview: WKWebView?
    let wkWebviewConfig = WKWebViewConfiguration()
    
    var viewModel = DetailMovieViewModel()
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                HUD.show(.progress, onView: self.view)
                self.view.isUserInteractionEnabled = false
            } else {
                HUD.hide()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    let disposeBag = DisposeBag()
    let numberFormatter = NumberFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Detail Movie"
        
        let backButtonSize:CGFloat = (self.navigationController?.navigationBar.frame.height ?? 0.0) - 8
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: backButtonSize, height: backButtonSize))
        backBtn.addTarget(self, action: #selector(self.backBtnTapped), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "back-arrow"), for: .normal)
        backBtn.contentMode = .scaleAspectFit
        backBtn.frame = CGRect(x: 0, y: 0, width: backButtonSize, height: backButtonSize)
        let backButton = UIBarButtonItem.init()
        backButton.customView = backBtn
        
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
        self.setupBinding()
        self.fetchData()
    }
    
    private func setupView() {
        trailerView.isHidden = true
        posterImageView.layer.cornerRadius = 4.0
        
        imagesCollectionView.register(UINib(nibName: "MovieImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieImageCollectionViewCell")
        imagesCollectionView.isPagingEnabled = true
        trailerCollectionView.register(UINib(nibName: "TrailerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrailerCollectionViewCell")
        reviewCollectionView.register(UINib(nibName: "ReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCollectionViewCell")
        
        numberFormatter.decimalSeparator = "."
        numberFormatter.currencyCode = ""
        
        watchNowButton.layer.cornerRadius = 4.0
        
        wkWebviewConfig.allowsInlineMediaPlayback = true
        wkWebview = WKWebView(frame: self.trailerContentView.frame, configuration: wkWebviewConfig)
        trailerContentView.addSubview(self.wkWebview!)
    }
    
    private func setupBinding() {
        self.viewModel.detailPublished.subscribe(onNext: { model in
            guard model.id != 0 else {
                self.updateDetailView()
                self.viewModel.requestImageList()
                self.viewModel.requestMovieWatchProvider()
                return
            }
            self.updateDetailView()
            self.viewModel.requestImageList()
            self.viewModel.requestMovieWatchProvider()
        }).disposed(by: disposeBag)
        
        self.viewModel.imagesPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.updateImagesView()
                self.viewModel.requestVideoList()
                return
            }
            self.updateImagesView()
            self.viewModel.requestVideoList()
        }).disposed(by: disposeBag)
        
        self.viewModel.videosPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.updateVideosView()
                self.viewModel.requestReviewList()
                return
            }
            self.updateVideosView()
            self.viewModel.requestReviewList()
        }).disposed(by: disposeBag)
        
        self.viewModel.reviewsPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.isLoading = false
                self.updateReviewsView()
                return
            }
            
            self.isLoading = false
            self.updateReviewsView()
        }).disposed(by: disposeBag)
        
        self.viewModel.watchProvidersPublished.subscribe(onNext: { model in
            if let link = model.US?.link {
                self.watchNowButton.isEnabled = true
                self.watchNowButton.backgroundColor = UIColor(red: 24/255, green: 168/255, blue: 65/255, alpha: 1.0)
            }
            else if let link = model.CA?.link {
                self.watchNowButton.isEnabled = true
                self.watchNowButton.backgroundColor = UIColor(red: 24/255, green: 168/255, blue: 65/255, alpha: 1.0)
            }
            else if let link = model.AU?.link {
                self.watchNowButton.isEnabled = true
                self.watchNowButton.backgroundColor = UIColor(red: 24/255, green: 168/255, blue: 65/255, alpha: 1.0)
            }
            else if let link = model.BO?.link {
                self.watchNowButton.isEnabled = true
                self.watchNowButton.backgroundColor = UIColor(red: 24/255, green: 168/255, blue: 65/255, alpha: 1.0)
            }
            else {
                self.watchNowButton.isEnabled = false
                self.watchNowButton.backgroundColor = .gray
            }
        }).disposed(by: disposeBag)
        
        self.watchNowButton.rx.tap
            .subscribe(onNext : { _ in
                // this is the value of mySwitch
                if let urlProvider = self.viewModel.watchProviders?.US?.link, let url = URL(string: urlProvider) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                else if let urlProvider = self.viewModel.watchProviders?.CA?.link, let url = URL(string: urlProvider) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                else if let urlProvider = self.viewModel.watchProviders?.AU?.link, let url = URL(string: urlProvider) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                else if let urlProvider = self.viewModel.watchProviders?.BO?.link, let url = URL(string: urlProvider) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.trailerCloseBtn.rx.tap
            .subscribe(onNext : { _ in
                // this is the value of mySwitch
                self.wkWebview?.stopLoading()
                self.trailerView.isHidden = true
                self.navigationController?.navigationBar.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchData() {
        self.isLoading = true
        self.viewModel.requestDetailMovie()
    }
    
    private func updateDetailView() {
        guard let detail = self.viewModel.detailMovie else {
            self.posterImageView.image = UIImage(named: "empty-image")
            self.posterImageView.backgroundColor = UIColor.lightGray
            self.movieTitleLabel.text = "-"
            self.voteCountLabel.text = "0"
            self.movieRatedView.isHidden = true
            self.movieGenreLabel.text = "-"
            self.movieOverviewLabel.text = " "
            return
        }
        
        self.movieTitleLabel.text = detail.original_title
        self.voteCountLabel.text = numberFormatter.string(from: NSNumber(value: detail.vote_count))
        self.movieRatedView.isHidden = !detail.adult
        var genreTxt = ""
        for genre in detail.genres {
            if genreTxt == "" {
                genreTxt += genre.name
            } else {
                genreTxt += " | " + genre.name
            }
        }
        self.movieGenreLabel.text = genreTxt
        self.movieOverviewLabel.text = detail.overview
        
        if let posterPath = detail.poster_path, let url = URL.init(string: ApiManager.url_media + posterPath) {
            self.posterImageView.af.setImage(withURL: url)
            self.posterImageView.backgroundColor = .clear
        }
    }
    
    private func updateImagesView() {
        self.imagesCollectionView.reloadData()
    }
    
    private func updateVideosView() {
        self.trailerCollectionView.reloadData()
    }
    
    private func updateReviewsView() {
        self.reviewCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func backBtnTapped() {
        self.dismiss(animated: true)
    }
    
}

extension DetailMovieViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView {
            return self.viewModel.listImages.count
        }
        else if collectionView == trailerCollectionView {
            return self.viewModel.listVideos.count
        }
        else if collectionView == reviewCollectionView {
            return self.viewModel.listReviews.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImageCollectionViewCell", for: indexPath) as! MovieImageCollectionViewCell
            
            collectionView.allowsSelection = false
            
            let model = self.viewModel.listImages[indexPath.row]
            cell.imageData = model
            
            return cell
        }
        else if collectionView == trailerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrailerCollectionViewCell", for: indexPath) as! TrailerCollectionViewCell
            
            collectionView.allowsSelection = true
            let model = self.viewModel.listVideos[indexPath.row]
            cell.videoData = model
            
            return cell
        }
        else if collectionView == reviewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
            
            collectionView.allowsSelection = true
            let model = self.viewModel.listReviews[indexPath.row]
            cell.reviewData = model
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        if collectionView == imagesCollectionView {
            width = collectionView.frame.width
            height = collectionView.frame.height
        }
        else if collectionView == trailerCollectionView {
            height = collectionView.frame.height
            width = height * 1.375
        }
        else if collectionView == reviewCollectionView {
            height = collectionView.frame.height
            width = height * 1.4
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trailerCollectionView {
            let model = self.viewModel.listVideos[indexPath.row]
            self.navigationController?.navigationBar.isHidden = true
            trailerView.isHidden = false
            let urlVideo = "https://www.youtube.com/embed/" + model.key + "?playsinline=1?autoplay=1"
            print("Open youtube trailer")
            print(urlVideo)
            if let url = URL(string: urlVideo) {
                var youtubeRequest = URLRequest(url: url)
                wkWebview?.load(youtubeRequest)
            }
        }
        else if collectionView == reviewCollectionView {
            let model = self.viewModel.listReviews[indexPath.row]
            print("Show modal detail review")
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
