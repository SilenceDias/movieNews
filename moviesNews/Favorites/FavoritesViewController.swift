//
//  MainViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit
import SnapKit
import CoreData

class FavoritesViewController: UIViewController {
    
    // MARK: Properties
    
    private lazy var favoriteMovies:[NSManagedObject] = [] {
        didSet{
            self.movieTableView.reloadData()
        }
    }
    
    // MARK: UI Components
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Favorites"
        return view
    }()
    
    private lazy var movieTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        view.configure(image: "no_favorites_pic", with: "No Favourites", and: "You haven’t liked any items yet.")
        return view
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
        if favoriteMovies.isEmpty {
            self.handleEmptyStateView(show: true)
        }
        else {
            self.handleEmptyStateView(show: false)
        }
    }
    
    // MARK: Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = .black
        [titleLabel, movieTableView, emptyStateView].forEach {
            view.addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        movieTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(movieTableView)
        }
    }
    
    private func loadMovies(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        do {
            favoriteMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not ferch data, error: \(error)")
        }
    }
    
    private func handleEmptyStateView(show: Bool){
        emptyStateView.isHidden = !show
    }
}

// MARK: TableViewDelegate, DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = favoriteMovies[indexPath.row]
        let title = movie.value(forKeyPath: "title") as? String
        let posterPath =  movie.value(forKeyPath: "posterPath") as? String
        let releaseDate = movie.value(forKeyPath: "date") as? String
        let voteRating = movie.value(forKeyPath: "rating") as? Double
        cell.configure(title: title ?? "", image: posterPath ?? "", date: releaseDate ?? "", rating: voteRating ?? 0.0)
        cell.selectionStyle = .none
        cell.deleteHeart()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsController = MovieDetailsViewController()
        let movie = favoriteMovies[indexPath.row]
        let id = movie.value(forKeyPath: "id") as? Int
        movieDetailsController.movidId = id ?? 0
        movieDetailsController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsController, animated: true)
    }
}

