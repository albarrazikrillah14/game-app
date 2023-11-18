//
//  ImageDownloader.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import Foundation

class NetworkService {
    let apiKeys = ""
    let mainUrl = "https://api.rawg.io/api/"
    
    
    func getGames(success: @escaping(GameResponse) -> Void, error: @escaping(String) -> Void) {
        var urlComponent = URLComponents(string: "\(mainUrl)games")

        urlComponent?.queryItems = [
            URLQueryItem(name: "key", value: apiKeys)
        ]
        var urlRequest = URLRequest(url: (urlComponent?.url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, err in
            if err == nil {
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(GameResponse.self, from: data)
                        success(result)
                    }
                } catch let jsonError {
                    print("JSON ERROR = \(jsonError.localizedDescription)")
                    error(jsonError.localizedDescription.description)
                }
            } else {
                print("Error \(err.debugDescription)")
                error(err.debugDescription)
            }
        }

        task.resume()
    }

    func getSearchGame(strQuery: String, success: @escaping(GameResponse) -> Void, error: @escaping(String) -> Void) {
        var urlComponent = URLComponents(string: "\(mainUrl)games")

        urlComponent?.queryItems = [
            URLQueryItem(name: "search", value: strQuery),
            URLQueryItem(name: "key", value: apiKeys)
        ]
        var urlRequest = URLRequest(url: (urlComponent?.url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, err in
            if err != nil {
                print("Error \(err.debugDescription)")
                error(err.debugDescription)
            } else {
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(GameResponse.self, from: data)
                        success(result)
                    }
                } catch let jsonError {
                    print("JSON ERROR = \(jsonError.localizedDescription)")
                    error(jsonError.localizedDescription.description)
                }
            }
        }
        task.resume()
    }

    func getDetailGame(id: String, success : @escaping(GameDetailResponse) -> Void, error : @escaping(String) -> Void) {
        var urlComponent = URLComponents(string: "\(mainUrl)games/\(id)")

        urlComponent?.queryItems = [
            URLQueryItem(name: "key", value: apiKeys)
        ]

        var urlRequest = URLRequest(url: (urlComponent?.url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) {data, _, err in
            if err != nil {
                print("Error \(err.debugDescription)")
                error(err.debugDescription)
            } else {
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(GameDetailResponse.self, from: data)
                        success(result)
                    }
                } catch let jsonError {
                    print("JSON ERROR = \(jsonError.localizedDescription)")
                    error(jsonError.localizedDescription.description)
                }
            }
        }
        task.resume()
    }
}

extension NetworkService {
    func gameMapper(input gameResponses: [GameModel]) -> [Game] {
        return gameResponses.map { result in
            return Game(
                id: result.id,
                name: result.name,
                releaseDate: result.releaseDate!,
                rating: result.rating!,
                image: result.gameImage!
                
            )
        }
    }
    
    func gameDetailMapper(input gameDetailResponse: GameDetailResponse) -> GameDetail {
        return GameDetail(
            id: gameDetailResponse.id,
            name: gameDetailResponse.name,
            releaseDate: gameDetailResponse.released,
            rating: gameDetailResponse.rating,
            image: gameDetailResponse.backgroundImage,
            description: gameDetailResponse.description
        )
    }
}
