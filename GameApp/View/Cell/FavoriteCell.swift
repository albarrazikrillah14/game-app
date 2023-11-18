//
//  FavoriteCell.swift
//  GameApp
//
//  Created by Raihan on 18/11/23.
//

import UIKit

class FavoriteCell: UICollectionViewCell {

    @IBOutlet weak var favoriteRate: UILabel!
    @IBOutlet weak var favoriteReleaseDate: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
