//
//  ViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    private func configureUI() {
        view.backgroundColor = .white
        
        // 라벨 설정
        label.text = "안녕하세요"
        label.textColor = .black
        
        view.addSubview(label)
        
        // SnapKit으로 오토레이아웃 설정
        label.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()  // 가운데 정렬 유지
            make.centerY.equalToSuperview().offset(-300)  // 중앙에서 위로 40포인트
        }
        
    }

}

