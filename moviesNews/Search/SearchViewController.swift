//
//  SearchViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 16.01.2024.
//

import UIKit
import CoreData

class SearchViewController: BaseViewController {
    //MARK: Properties
    private var networkManager = NetworkManager.shared
    private var favoriteMovies: [NSManagedObject] = []
    
    //MARK: UI components
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Search"
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.barTintColor = .white
        return search
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
    
    private lazy var movie:[Result] = [] {
        didSet{
            self.movieTableView.reloadData()
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadFavorites()
    }
    
    //MARK: Methods
    private func setupViews(){
        view.backgroundColor = .white
        [titleLabel, searchBar, movieTableView].forEach {
            view.addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        movieTableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(16)
        }
    }
    
    private func loadMovieList(query: String){
        networkManager.loadMoviesSearch(query: query) { [weak self] movies in
            self?.showLoader()
            self?.movie = movies
            self?.hideLoader()
        }
    }
    
    private func loadFavorites(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        do {
            favoriteMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Could not ferch data, error: \(error)")
        }
    }
    
    private func saveFavoriteMoview(with movie: Result){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext) else { return }
        let favoriteMovie = NSManagedObject(entity: entity, insertInto: managedContext)
        favoriteMovie.setValue(movie.id, forKey: "id")
        favoriteMovie.setValue(movie.title, forKey: "title")
        favoriteMovie.setValue(movie.posterPath, forKey: "posterPath")
        favoriteMovie.setValue(movie.releaseDate, forKey: "date")
        favoriteMovie.setValue(movie.voteAverage, forKey: "rating")
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save, error: \(error)")
        }
    }
    
    private func deleteFavoriteMoview(with movie: Result){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        let predicate1 = NSPredicate(format: "id == %@", "\(movie.id)")
        let predicate2 = NSPredicate(format: "title == %@", movie.title)
        let predicate3 = NSPredicate(format: "posterPath == %@", movie.posterPath)
        let predicate4 = NSPredicate(format: "date == %@", movie.releaseDate)
        let predicate5 = NSPredicate(format: "rating == %@", "\(movie.voteAverage)")
        let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2, predicate3, predicate4, predicate5])
        fetchRequest.predicate = predicateAll
        do {
            let result = try managedContext.fetch(fetchRequest)
            let data = result.first
            if let data {
                managedContext.delete(data)
            }
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete, error: \(error)")
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        loadMovieList(query: searchText)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = movie[indexPath.row]
        cell.configure(title: movie.title, image: movie.posterPath, date: movie.releaseDate, rating: movie.voteAverage)
        let isFavoriteMovie = !self.favoriteMovies.filter({ ($0.value(forKeyPath: "id") as? Int) == movie.id }).isEmpty
        cell.toggleFavoriteHeart(with: isFavoriteMovie)
        cell.didTapFavorite = { [weak self] in
            guard let self else { return }
            let isFavoriteMovie = !self.favoriteMovies.filter({ ($0.value(forKeyPath: "id") as? Int) == movie.id }).isEmpty
            cell.toggleFavoriteHeart(with: !isFavoriteMovie)
            if isFavoriteMovie {
                self.deleteFavoriteMoview(with: movie)
            }
            else {
                self.saveFavoriteMoview(with: movie)
            }
            self.loadFavorites()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsController = MovieDetailsViewController()
        let movie = movie[indexPath.row]
        movieDetailsController.movidId = movie.id
        self.navigationController?.pushViewController(movieDetailsController, animated: true)
    }
    
    
}
