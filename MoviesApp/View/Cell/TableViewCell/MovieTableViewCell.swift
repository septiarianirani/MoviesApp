//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Mac on 28/08/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieRatedLabel: UILabel!
    @IBOutlet var moviePopularityLabel: UILabel!
    
    var movieData: MovieItemModel? {
        didSet {
            guard let data = movieData else {
                return
            }
            
            movieTitleLabel.text = data.title
            if let posterPath = data.poster_path, let url = URL.init(string: ApiManager.url_media + posterPath) {
                posterImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 2.0
        posterImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
