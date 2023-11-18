//
//  GameCell.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var gameBackground: UIView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameRelease: UILabel!
    @IBOutlet weak var gameRate: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
