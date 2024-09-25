//
//  ReviewCollectionViewCell.swift
//  MoviesApp
//
//  Created by Mac on 05/09/24.
//

import UIKit
import AlamofireImage

class ReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet var reviewContentView: UIView!
    @IBOutlet var reviewAuthorImageView: UIImageView! {
        didSet {
            self.reviewAuthorImageView.layer.cornerRadius = self.reviewAuthorImageView.frame.height / 2
            self.reviewAuthorImageView.clipsToBounds = true
        }
    }
    @IBOutlet var reviewNameLabel: UILabel!
    @IBOutlet var reviewDateLabel: UILabel!
    @IBOutlet var reviewContentLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var reviewData: MovieReviewModel? {
        didSet {
            guard let data = reviewData else {
                reviewNameLabel.text = "-"
                reviewDateLabel.text = "-"
                reviewContentLabel.text = "-"
                reviewAuthorImageView.image = UIImage(named: "profile-user")
                return
            }
            
            reviewNameLabel.text = data.author
            reviewContentLabel.text = data.content
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z''"
            if let createdDateStr = data.created_at, let createdDate = dateFormatter.date(from: createdDateStr) as? Date {
                dateFormatter.dateFormat = "HH:mm, dd MMMM yyyy"
                reviewDateLabel.text = dateFormatter.string(from: createdDate)
            }
            
            if let author = data.author_details, let authorImage = author.avatar_path, let url = URL.init(string: ApiManager.url_media + authorImage) {
                reviewAuthorImageView.af.setImage(withURL: url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reviewContentView.layer.cornerRadius = 4.0
        reviewContentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        reviewContentView.layer.shadowOpacity = 0.6
        reviewContentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        reviewContentView.layer.shadowRadius = 1.5
    }

}
