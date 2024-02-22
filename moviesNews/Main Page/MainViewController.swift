//
//  MainViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit
import SnapKit
import CoreData

class MainViewController: UIViewController {
    
    // MARK: Properties
    private var tappedGenreId: Int?
    private var isGenresShown: Bool = false
    private var titleLabelYPosition: Constraint!
    private var allMovies: [Result] = []
    private var filters = Themes.allCases
    private var networkManager = NetworkManager.shared
    private var selectedFillter = IndexPath(row: 0, section: 0)
    private var selectedGenre = IndexPath(row: 0, section: 0)
    private var currentArrow  = UIImage()
    private var favoriteMovies: [NSManagedObject] = []
    
    private lazy var movie:[Result] = [] {
        didSet{
            self.movieTableView.reloadData()
        }
    }
    private lazy var genres: [Genre] = [.init(id: 1, name: "All")] {
        didSet {
            self.genresCollection.reloadData()
        }
    }
    
    // MARK: UI Components
    private var containerView = UIView()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "MoviesNews"
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
    
    private lazy var filterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "filterCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var genresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "genreCell")
        view.isHidden = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var showGenresButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Genre", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private var arrowGenresButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.spacing = 2
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let genresStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        stack.backgroundColor = .clear
        return stack
    }()
    
    private var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        return view
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadMovieList(filter: .nowPlaying, genreId: tappedGenreId)
        loadGenres()
        loadFavorites()
        handleRecommendations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
        self.filterCollection.selectItem(at: selectedFillter, animated: false, scrollPosition: .top)
        self.genresCollection.selectItem(at: selectedGenre, animated: false, scrollPosition: .top)
    }
    
    // MARK: Methods
    @objc private func showGenreTapped(_ sender: UIButton){
        self.genresCollection.isHidden = isGenresShown ? true : false
        currentArrow = (isGenresShown ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up"))!
        arrowGenresButton.setImage(currentArrow, for: .normal)
        isGenresShown.toggle()
    }
    
    private func animate(){
        UIView.animateKeyframes(withDuration: 2.15, delay: 0.5, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                self.titleLabel.alpha = 1.0
            })

            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.28, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.27, animations: {
                self.titleLabelYPosition.update(offset: -(self.view.safeAreaLayoutGuide.layoutFrame.size.height / 2) + 10)
                self.view.layoutSubviews()
            })

            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.05, animations: {
                self.titleLabelYPosition.update(offset: -(self.view.safeAreaLayoutGuide.layoutFrame.size.height / 2 - 16))
                self.view.layoutSubviews()
            })

            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.15, animations: {
                self.containerView.alpha = 1.0
            })
        })
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = .black
        showGenresButton.addTarget(self, action: #selector(showGenreTapped(_ :)), for: .touchUpInside)
        arrowGenresButton.addTarget(self, action: #selector(showGenreTapped(_ :)), for: .touchUpInside)
        containerView.alpha = 0
        [titleLabel, containerView].forEach {
            view.addSubview($0)
        }
        [movieTableView, filterCollection, genresStack, emptyStateView].forEach {
            containerView.addSubview($0)
        }
        [showGenresButton, arrowGenresButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        [buttonStack, genresCollection].forEach {
            genresStack.addArrangedSubview($0)
        }
        showGenresButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        arrowGenresButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
        }
        buttonStack.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(90)
        }
        genresCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        filterCollection.snp.makeConstraints {make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(40)
        }
        genresStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(filterCollection.snp.bottom).offset(8)
        }
        movieTableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(genresStack.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            titleLabelYPosition = make.centerY.equalToSuperview().constraint
            make.center.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(movieTableView)
        }
    }
    
    private func handleEmptyStateView(show: Bool){
        emptyStateView.isHidden = !show
    }
    
    private func loadMovieList(filter: Themes, genreId: Int?){
        networkManager.loadMovieLists(filter: filter.urlPaths) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.allMovies = movies
                if let genreId = genreId {
                    self?.obtainMovieList(with: genreId)
                }
                else {
                    self?.movie = movies
                }
                self?.handleEmptyStateView(show: false)
            case .failure:
                self?.handleEmptyStateView(show: true)
            }
        }
    }
    
    private func loadGenres(){
        networkManager.loadGenres { [weak self] genres in
            genres.forEach { genre in
                self?.genres.append(genre)
            }
        }
    }
    
    private func obtainMovieList(with genreId: Int) {
        guard genreId != 1 else {
            movie = allMovies
            return
        }
        movie = allMovies.filter { movie in
            movie.genreIDS.contains(genreId)
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
    
    private func handleRecommendations(){
        if favoriteMovies.isEmpty {
            guard let firstMovie = movie.first else {
                return
            }
            UserDefaults.standard.setValue(firstMovie.id, forKey: "RecommendedMovieId")
        }
        else {
            return
        }
    }
}

// MARK: TableViewDelegate, DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
        movieDetailsController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailsController, animated: true)
    }
}

// MARK: CollectionViewDelegate, DataSource
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.filterCollection {
            return filters.count
        }
        else {
            return genres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.filterCollection {
            let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! CustomCollectionViewCell
            cell.configure(title: filters[indexPath.row].key, selectedBackgroundColor: .systemRed, unselectedBackgroundColor: .lightGray)
            cell.configureCustonTitle(with: UIFont.systemFont(ofSize: 14))
            return cell
        }
        else {
            let cell = genresCollection.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! CustomCollectionViewCell
            cell.configure(title: genres[indexPath.row].name, selectedBackgroundColor: .systemRed, unselectedBackgroundColor: .blue)
            cell.configureCustonTitle(with: UIFont.systemFont(ofSize: 14))
            cell.isSelected = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.filterCollection {
            loadMovieList(filter: filters[indexPath.row], genreId: tappedGenreId)
            selectedFillter = indexPath
        }
        if collectionView == self.genresCollection {
            obtainMovieList(with: genres[indexPath.row].id)
            tappedGenreId = genres[indexPath.row].id
            selectedGenre = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 35)
    }
}
