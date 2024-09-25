//
//  MovieImageCollectionViewCell.swift
//  MoviesApp
//
//  Created by Mac on 17/09/24.
//

import UIKit
import AlamofireImage

class MovieImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var movieImageView: UIImageView!
    
    var imageData: MovieImageModel? {
        didSet {
            if let movieImage = imageData?.file_path, let url = URL.init(string: ApiManager.url_media + movieImage) {
                movieImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
