import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var games: [Game] = [] {
        didSet {
            collectionView.reloadData()
            emptyView.isHidden = !games.isEmpty
        }
    }

    private var gameProvider = GameProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteCell")
    }

    func loadGames() {
        gameProvider.getAllGames { [weak self] games in
            DispatchQueue.main.async {
                self?.games = games.reversed()
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = games[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.favoriteName.text = data.name
        cell.favoriteRate.text = "\(data.rating)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: data.releaseDate)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM, d YYYY"
        cell.favoriteReleaseDate.text = dateFormatter1.string(from: date ?? Date())

        
        let imageUrlString = data.image
        if let imageUrl = URL(string: imageUrlString) {
            
            let session = URLSession.shared
            let task = session.dataTask(with: imageUrl) { [weak self] (data, _, error) in
                if let error = error {
                    print("Error fetching image: \(error.localizedDescription)")
                }

                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.favoriteImage.image = image
                    }
                }
            }
            task.resume()

        }

        
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.isNavigationBarHidden = true
        showDetailViewController(id: games[indexPath.row].id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 100)
    }
}

extension UIViewController {
    func showFavoriteViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "favorite") as! FavoriteViewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
