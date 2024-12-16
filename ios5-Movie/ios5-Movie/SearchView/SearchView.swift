//
//  SearchView.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/16/24.
//

import UIKit

class SearchView: UIView {
    let manager = DummyMovieDataManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
