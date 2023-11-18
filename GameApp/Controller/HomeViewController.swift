//
//  ViewController.swift
//  GameApp
//
//  Created by Raihan on 15/11/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var querySearch: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UIView!
    
    private var games: [Game] = [] {
        didSet {
            if games.count == 0 {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loading.startAnimating()
        getGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setup() {
        searchBar.layer.cornerRadius = 16
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        querySearch.delegate = self
    }
    @IBAction func profileButtonTapped(_ sender: Any) {
        navigationController?.isNavigationBarHidden = true
        self.showProfileViewController()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        navigationController?.isNavigationBarHidden = true
        self.showFavoriteViewController()
    }
    
    func getGames() {
        let network = NetworkService()
        
        network.getGames { result in
            DispatchQueue.main.async {
                self.games = network.gameMapper(input: result.results!)
                self.collectionView.reloadData()
                self.loading.isHidden = true
            }
        } error: { error in
            self.games.removeAll()
            self.collectionView.reloadData()
        }

    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = games[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        
        cell.gameName.text = data.name
        cell.gameRate.text = "\(data.rating)"
        cell.gameRelease.text = data.releaseDate
        
        let imageUrlString = data.image
        if let imageUrl = URL(string: imageUrlString) {
            
            let session = URLSession.shared
            let task = session.dataTask(with: imageUrl) { [weak self] (data, _, error) in
                if let error = error {
                    print("Error fetching image: \(error.localizedDescription)")
                }

                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.gameImage.image = image
                    }
                }
            }
            task.resume()

        }

        cell.gameBackground.layer.cornerRadius = 8
        cell.gameImage.layer.cornerRadius = 8
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.isNavigationBarHidden = true
        self.showDetailViewController(id: games[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width - 32) / 2) - 7
        return CGSize( width: width, height: 200)
    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let query = textField.text
        
        if(((query?.isEmpty) == false)) {
            let network = NetworkService()
            network.getSearchGame(strQuery: query!) { result in
                DispatchQueue.main.async {
                    self.games = network.gameMapper(input: result.results!)
                    self.collectionView.reloadData()
                    self.loading.isHidden = true
                }
            } error: { String in
                DispatchQueue.main.async {
                    self.games.removeAll()
                    self.collectionView.reloadData()
                }
            }
        } else {
            getGames()
        }

    }
}
