import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
}

extension ImagesListCell {
    public func setupUI(image: UIImage, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "Favorites Active") : UIImage(named: "Favorites Inactive")
        likeButton.setImage(likeImage, for: .normal)
    }
}
