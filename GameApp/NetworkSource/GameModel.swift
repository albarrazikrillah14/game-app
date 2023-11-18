//
//  GameModel.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import Foundation

enum DownloadState {
    case new, downloaded, failed
}

class Game {
    let id: Int
    let name: String
    let releaseDate: String
    let rating: Double
    let image: String
    
    init(id: Int, name: String, releaseDate: String, rating: Double, image: String) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.image = image
    }
}


class GameDetail {
    let id: Int
    let name: String
    let releaseDate: String
    let rating: Double
    let image: String
    let description: String

    init(id: Int, name: String, releaseDate: String, rating: Double, image: String, description: String) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.image = image
        self.description = description
    }
}
