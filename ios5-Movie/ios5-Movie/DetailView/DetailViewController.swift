//
//  DetailViewController.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
    // MARK: - DetailView Controller

final class DetailViewController: UIViewController {
    
    let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    private func setupDatas() {
        // 셀 선택된 데이터 넘기기
    }
    
    private func setupButton() {
        detailView.reservationButton.addTarget(self, action: #selector(reservationButtonTapped), for: .touchUpInside)
    }
    /// 영화 정보 넘기기
    @objc func reservationButtonTapped() {
        let VC = PaymentViewController()
       // VC.movieNameValueLabel.text = detailView.movieNameLable.text
        
       // self.present(VC, animated: true, completion: nil)
    }
}
