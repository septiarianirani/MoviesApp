//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import UIKit
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var movieDateLabel: UILabel!
    
    var categoryMovie: HomeMovieCategory?
    var movieData: MovieItemModel? {
        didSet {
            guard let category = categoryMovie else {
                return
            }
            
            switch category {
            case .nowPlaying:
                movieDateLabel.isHidden = true
            case .popular:
                movieDateLabel.isHidden = true
            case .upcoming:
                movieDateLabel.isHidden = false
            }
            
            guard let data = movieData else {
                return
            }
            
            movieNameLabel.text = data.title
            if let posterPath = data.poster_path, let url = URL.init(string: ApiManager.url_media + posterPath) {
                posterImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 4.0
        posterImageView.clipsToBounds = true
    }

}
