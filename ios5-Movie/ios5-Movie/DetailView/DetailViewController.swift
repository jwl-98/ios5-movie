//
//  DetailViewController.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
    // MARK: - DetailView Controller

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    
    private let networkManager = NetworkManager.shared
    
    override func loadView() {
        self.view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}


