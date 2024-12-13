//
//  DummyMovieData.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import Foundation
import UIKit
class DummyMovieDataManager {
    private var movieDataArray: [DummyMovie] = []
    
    func makeMovieData() {
        movieDataArray = [
            DummyMovie(movieImage: UIImage(named: "데드풀과 울버린.png"),
                       movieName: "데드풀과 울버린",
                       movieDescription: "데드풀과 울버린 설멍"),
            DummyMovie(movieImage: UIImage(named: "완벽한 우리집으로.png"),
                       movieName: "완벽한 우리집으로",
                       movieDescription: "완벽한 우리집으로 설명"),
            DummyMovie(movieImage: UIImage(named: "크레이븐 더 헌터.png"),
                       movieName: "크레이븐 더 헌터",
                       movieDescription: "크레이븐 더 헌터"),
            DummyMovie(movieImage: UIImage(named: "라팔마.png"),
                       movieName: "라팔마",
                       movieDescription: "라팔마 설명"),
            DummyMovie(
                movieImage: UIImage(named: "헤레틱.png"),
                movieName: "헤레틱",
                movieDescription: "헤레틱 설명"
            ),
            DummyMovie(
                movieImage: UIImage(named: "시크릿레벨.png"),
                movieName: "시크릿레벨",
                movieDescription: "시크릿레벨 설명"
            ),
            DummyMovie(
                movieImage: UIImage(named: "베놈라스트댄스.png"),
                movieName: "베놈라스트댄스",
                movieDescription: "베놈라스트댄스 설명"
            ),
            DummyMovie(
                movieImage: UIImage(named: "레드원.png"),
                movieName: "레드원",
                movieDescription: "레드원 설명"
            ),
            DummyMovie(
                movieImage: UIImage(named: "코드.png"),
                movieName: "코드",
                movieDescription: "코드 설명"
            )
        ]
    }
    func getDummyMovieData() -> [DummyMovie] {
        return movieDataArray
    }
}
