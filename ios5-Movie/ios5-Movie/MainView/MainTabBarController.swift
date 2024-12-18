//
// MainTabBarController.swift
// ios5-Movie
//
// Created by 진욱의 Macintosh on 12/13/24.
//
import UIKit
class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
  }
  private func setupTabs() {
    let movieListVC = MovieListViewController()
    movieListVC.tabBarItem = UITabBarItem(title: "영화 목록", image: UIImage(systemName: "film"), tag: 0)
    let searchVC = UIViewController()
    searchVC.view.backgroundColor = .white
    searchVC.tabBarItem = UITabBarItem(title: "영화 검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    let myPageVC = UIViewController()
    myPageVC.view.backgroundColor = .white
    myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 2)
    viewControllers = [movieListVC, searchVC, myPageVC]
  }
}
