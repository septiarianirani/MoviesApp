//
//  TrailerCollectionViewCell.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import UIKit
import AlamofireImage

class TrailerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var trailerImageView: UIImageView!
    @IBOutlet var playIconView: UIImageView!
    
    var videoData: MovieVideoItemModel? {
        didSet {
            guard let videoKey = videoData?.key else {
                return
            }
            let urlString = (ApiManager.url_youtube_thumbnail).replacingOccurrences(of: "{youtube_video_id}", with: videoKey)
            if let url = URL.init(string: urlString) {
                trailerImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trailerImageView.layer.cornerRadius = 4.0
        playIconView.layer.cornerRadius = playIconView.frame.height / 2
    }

}
