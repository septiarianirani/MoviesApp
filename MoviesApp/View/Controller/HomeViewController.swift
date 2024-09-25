//
//  HomeViewController.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import UIKit
import PKHUD
import Toast_Swift
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet var scrollingView: UIScrollView!
    @IBOutlet var upcomingSectionView: UIView!
    @IBOutlet var upcomingCollectionView: UICollectionView!
    @IBOutlet var nowPlayingSectionView: UIView!
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    @IBOutlet var gridListButton: UIButton!
    @IBOutlet var popularTableView: UITableView!
    @IBOutlet var popularTableHeight: NSLayoutConstraint!
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var popularCollectionHeight: NSLayoutConstraint!
    @IBOutlet var emptyPopularView: UIView!
    
    let disposeBag = DisposeBag()
    var isGrid: Bool = true
    var viewModel = HomeViewModel()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "MOVIE SHOW"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
        self.setupBinding()
        self.fetchData()
    }
    
    private func setupView() {
        emptyPopularView.isHidden = true
        
        upcomingCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        nowPlayingCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        popularCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        popularCollectionView.isScrollEnabled = false
        
        popularTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        popularTableView.separatorStyle = .none
        popularTableView.isScrollEnabled = false
        popularTableView.isHidden = true
    }
    
    private func setupBinding() {
        self.gridListButton.rx.tap
            .subscribe(onNext : { _ in
                // this is the value of mySwitch
                self.isGrid = !self.isGrid
                if self.isGrid {
                    self.gridListButton.setTitle("View List", for: .normal)
                    self.popularTableView.isHidden = true
                    self.popularCollectionView.isHidden = false
                    self.popularTableHeight.constant = self.popularCollectionHeight.constant
                } else {
                    self.gridListButton.setTitle("View Grid", for: .normal)
                    self.popularTableView.isHidden = false
                    self.popularCollectionView.isHidden = true
                    self.popularTableHeight.constant = CGFloat(self.viewModel.listPopular.count) * 104.0
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.upcomingPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.upcomingCollectionView.reloadData()
                return
            }
            self.upcomingCollectionView.reloadData()
            self.viewModel.requestDataMovies(category: .nowPlaying)
        }).disposed(by: disposeBag)
        
        self.viewModel.nowPlayingPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.nowPlayingCollectionView.reloadData()
                return
            }
            self.nowPlayingCollectionView.reloadData()
            self.viewModel.requestDataMovies(category: .popular)
        }).disposed(by: disposeBag)
        
        self.viewModel.popularPublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.popularCollectionView.reloadData()
                self.popularTableView.reloadData()
                self.isLoading = false
                return
            }
            self.popularCollectionView.reloadData()
            self.popularTableView.reloadData()
            self.isLoading = false
            
            if self.viewModel.listPopular.count > 0 {
                self.emptyPopularView.isHidden = true
                self.popularTableHeight.constant = CGFloat(self.viewModel.listPopular.count) * 104.0
                
                let widthCell = ((self.popularCollectionView.frame.width) - 16) / 2
                let heightCell = widthCell * 1.6
                if self.viewModel.listPopular.count % 2 == 0 {
                    self.popularCollectionHeight.constant = CGFloat(self.viewModel.listPopular.count / 2) * heightCell
                } else {
                    self.popularCollectionHeight.constant = (CGFloat(self.viewModel.listPopular.count / 2) + 1) * heightCell
                }
                
                if self.isGrid {
                    self.popularTableHeight.constant = self.popularCollectionHeight.constant ?? 0.0
                } else {
                    self.popularTableHeight.constant = CGFloat(self.viewModel.listPopular.count) * 104.0
                }
            } else {
                self.emptyPopularView.isHidden = false
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchData() {
        self.isLoading = true
        self.viewModel.requestDataMovies(category: .upcoming)
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case upcomingCollectionView:
            return self.viewModel.listUpcoming.count
        case nowPlayingCollectionView:
            return self.viewModel.listNowPlaying.count
        case popularCollectionView:
            return self.viewModel.listPopular.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        var model = self.viewModel.listUpcoming[indexPath.row]
        
        switch collectionView {
        case upcomingCollectionView:
            model = self.viewModel.listUpcoming[indexPath.row]
            cell.categoryMovie = .upcoming
        case nowPlayingCollectionView:
            model = self.viewModel.listNowPlaying[indexPath.row]
            cell.categoryMovie = .nowPlaying
        case popularCollectionView:
            model = self.viewModel.listPopular[indexPath.row]
            cell.categoryMovie = .popular
        default:
            break
        }
        
        cell.movieData = model
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        switch collectionView {
        case upcomingCollectionView:
            height = upcomingCollectionView.frame.height
            width = height / 1.7
        case nowPlayingCollectionView:
            height = upcomingCollectionView.frame.height
            width = height / 1.7
        case popularCollectionView:
            width = (popularCollectionView.frame.width - 32) / 2
            height = width * 1.6
        default:
            break
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model = self.viewModel.listUpcoming[indexPath.row]
        switch collectionView {
        case upcomingCollectionView:
            model = self.viewModel.listUpcoming[indexPath.row]
        case nowPlayingCollectionView:
            model = self.viewModel.listNowPlaying[indexPath.row]
        case popularCollectionView:
            model = self.viewModel.listPopular[indexPath.row]
        default:
            break
        }
        
        // Navigate to Detail Movie
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller = DetailMovieViewController()
        controller.viewModel.movieId = model.id
        let navController = UINavigationController(rootViewController: controller)
        controller.modalPresentationStyle = .fullScreen
        navController.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(controller, animated: true)
        self.present(navController, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listPopular.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let model = self.viewModel.listPopular[indexPath.row]
        cell.movieData = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.listPopular[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
