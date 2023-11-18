//
//  DetailViewController.swift
//  GameApp
//
//  Created by Raihan on 15/11/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailRate: UILabel!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    var id: Int = 0
    private var data: GameDetail?
    private var games: [Game] = [] {
        didSet {
            loadGames()
        }
    }
    
    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteButton.image = UIImage(named: "like")
            } else {
                favoriteButton.image = UIImage(systemName: "heart")
                ()
            }

        }
    }
    private var gameProvider: GameProvider = GameProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadGames()
        getData()
        setup()
    }
    
    func getData() {
        let network = NetworkService()
        loading.startAnimating()
        network.getDetailGame(id: "\(id)") { result in
            DispatchQueue.main.async {
                let data = network.gameDetailMapper(input: result)
                self.data = data
                self.setupData()
                self.loading.isHidden = true
            }
        } error: {_ in
            self.loading.isHidden = true
        }

    }
    func setupData() {
        nav.title = self.data!.name.uppercased()
        detailName.text = self.data!.name
        detailRate.text = "\(data!.rating)"
        detailDescription.text = data!.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: data?.releaseDate ?? "")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM, d YYYY"
        detailDate.text = dateFormatter1.string(from: date ?? Date())
        
        let imageUrlString = data!.image
        if let imageUrl = URL(string: imageUrlString) {
            
            let session = URLSession.shared
            let task = session.dataTask(with: imageUrl) { [weak self] (data, _, error) in
                if let error = error {
                    print("Error fetching image: \(error.localizedDescription)")
                }

                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self!.detailImage.image = image
                    }
                }
            }
            task.resume()

        }
    }
    func setup() {
        backgroundView.layer.cornerRadius = 16
        detailImage.layer.cornerRadius = 16

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if isFavorite {
            favoriteButton.image = UIImage(named: "like")
            deleteFavorite()
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
            saveFavorite()
        }
    }
    
    private func loadGames() {
        self.gameProvider.getAllGames { games in
            DispatchQueue.main.async {
                self.games = games.reversed()
                self.checkIsContainFavorite()
            }
        }
    }
    
    private func checkIsContainFavorite() {
        if games.contains(where: {$0.id == self.id}) {
            isFavorite = true
        } else {
            isFavorite = false
        }
    }
    
    private func deleteFavorite() {
        self.gameProvider.deleteGame(self.id) { _ in
        }
    }

        private func saveFavorite() {
            getData()
            self.gameProvider.createGame(
                Game(id: data?.id ?? 0, name: data?.name ?? "", releaseDate: data?.releaseDate ?? "", rating: data?.rating ?? 0.0, image: data?.image ?? "")
            ) { _ in

            }
        }

    }

extension UIViewController {
    func showDetailViewController(id: Int) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "detail") as! DetailViewController
        viewController.id = id
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
