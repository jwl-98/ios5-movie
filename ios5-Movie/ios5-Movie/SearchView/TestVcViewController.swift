//
//  TestVcViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/16/24.
//

import UIKit
import SnapKit

class TestVcViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchVC = SearchViewController()
        let navController = UINavigationController(rootViewController: searchVC)
        setupNav(navController)
    }
    
    //네비게이션 바 설정
    private func setupNav(_ child: UIViewController) {
        addChild(child)
        
        [
            child.view
        ].forEach{self.view.addSubview($0)}
        
        child.view.snp.makeConstraints {
            $0.leading.equalTo(self.view)
            $0.trailing.equalTo(self.view)
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(self.view)
        }
    }

}


