//
//  ProfileViewController.swift
//  GameApp
//
//  Created by Raihan on 17/11/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setup();
    }
    
    func setup() {
        backgroundView.layer.cornerRadius = 16;
        profileImage.layer.cornerRadius = 16;
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func showProfileViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
