//
//  GameResponse.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import Foundation

struct GameResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [GameModel]?
}

struct GameModel: Codable {
    let id: Int
    let name: String
    let releaseDate: String?
    let rating: Double?
    let gameImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case releaseDate = "released"
        case rating
        case gameImage = "background_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM, d YYYY"
        releaseDate = dateFormatter1.string(from: date ?? Date())
        rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        gameImage = try container.decodeIfPresent(String.self, forKey: .gameImage) ?? ""
    }

    init(id: Int, name: String, releaseDate: String, rating: Double, gameImage: String) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.rating = rating
        self.gameImage = gameImage
    }
}
