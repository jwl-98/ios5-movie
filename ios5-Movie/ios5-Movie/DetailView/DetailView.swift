//
//  DetailView.swift
//  ios5-Movie
//
//  Created by t2023-m0033 on 12/16/24.
//

import UIKit
import SnapKit
import SwiftUI
// MARK: - DetailView UI

final class DetailView: UIView {
    
    
    private let detailImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        return image
    }()
    
    
    private lazy var imageContainView: UIView = {
        let view = UIView()
        view.addSubview(detailImageView)
        return view
    }()
    
    //MARK: - 생성자 셋팅
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    private func configureUI() {
        self.addSubview(imageContainView)
        
        imageContainView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(400)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(335)
            make.width.equalTo(238)
            
        }
    }
    
}
// MARK: - SwiftUI Preview Extension
extension DetailViewController {
    private struct Preview: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return DetailViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    func toPreview() -> some View {
        Preview()
    }
}

struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewController().toPreview()
    }
}
