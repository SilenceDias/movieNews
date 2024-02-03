//
//  MovieDetailsViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import UIKit
import Kingfisher
class MovieDetailsViewController: BaseViewController {
    
    // MARK: Properties
    var movidId = Int()
    var voteAvg: Int = 0
    private var networkManager = NetworkManager.shared
    
    private lazy var cast:[CastElement] = [] {
        didSet{
            self.castCollection.reloadData()
        }
    }
    
    private lazy var genres:[Genre] = [] {
        didSet{
            self.genresCollection.reloadData()
        }
    }
    
    // MARK: UI Components
    private var imageView = UIImageView()
    private var overviewView = CustomOverview()
    
    private lazy var genresCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "GenresCollectionViewCell")
        view.allowsSelection = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInset = .zero
        return scroll
    }()
    
    private let starsStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let genresAndReleaseStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let starsAndRatingStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let youTubeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "uTube")
        return image
    }()
    
    private let imdbImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "imdb")
        return image
    }()
    
    private let facebookImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "facebook")
        return image
    }()
    
    private let socialMediasStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.axis = .horizontal
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let allInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    private var contentView = UIView()
    
    private var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private var castLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Cast"
        view.numberOfLines = 1
        return view
    }()
    
    private var linksLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Links"
        view.numberOfLines = 1
        return view
    }()
    
    private var releaseLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    private var ratingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    private var votesLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        return view
    }()
    
    private let ratingAndVotesStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        stack.backgroundColor = .clear
        return stack
    }()
    
    private lazy var castCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: Methods
    private func setupViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.backgroundColor = .white
        [ratingLabel, votesLabel].forEach {
            ratingAndVotesStack.addArrangedSubview($0)
        }
        [starsStack, ratingAndVotesStack].forEach {
            starsAndRatingStack.addArrangedSubview($0)
        }
        [releaseLabel, genresCollection].forEach {
            genresAndReleaseStack.addArrangedSubview($0)
        }
        [genresAndReleaseStack, starsAndRatingStack].forEach{
            allInfoStack.addArrangedSubview($0)
        }
        [imdbImage, youTubeImage, facebookImage].forEach {
            socialMediasStack.addArrangedSubview($0)
        }
        [imageView, titleLabel, allInfoStack, overviewView, castLabel, castCollection, linksLabel, socialMediasStack].forEach {
            contentView.addSubview($0)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        imageView.snp.makeConstraints {make in
            make.height.equalTo(425)
            make.width.equalTo(325)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        genresAndReleaseStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        genresCollection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        allInfoStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.left.equalToSuperview()
        }
        overviewView.snp.makeConstraints { make in
            make.top.equalTo(allInfoStack.snp.bottom).offset(8)
            make.right.left.equalToSuperview()
        }
        starsAndRatingStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        castCollection.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        linksLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollection.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        socialMediasStack.snp.makeConstraints { make in
            make.top.equalTo(linksLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        let tapGRUTube = UITapGestureRecognizer(target: self, action: #selector(self.youTubeTapped))
        youTubeImage.addGestureRecognizer(tapGRUTube)
        youTubeImage.isUserInteractionEnabled = true
        let tapGRImdb = UITapGestureRecognizer(target: self, action: #selector(self.imdbTapped))
        imdbImage.addGestureRecognizer(tapGRImdb)
        imdbImage.isUserInteractionEnabled = true
        let tapGRFacebook = UITapGestureRecognizer(target: self, action: #selector(self.facebookTapped))
        facebookImage.addGestureRecognizer(tapGRFacebook)
        facebookImage.isUserInteractionEnabled = true
    }
    
    private func loadData(){
        let group = DispatchGroup()
        showLoader()
        group.enter()
        networkManager.loadMovieDetails(id: movidId) { [weak self] movieDetails in
            guard let posterPath = movieDetails.posterPath else{return}
            self?.voteAvg = Int(round(movieDetails.voteAverage ?? 0))
            self?.createStarsStack()
            self?.genres = movieDetails.genres
            self?.titleLabel.text = movieDetails.originalTitle
            self?.title = movieDetails.originalTitle
            self?.releaseLabel.text = "Release Date: \(movieDetails.releaseDate ?? "2022")"
            self?.ratingLabel.text = " \(movieDetails.voteAverage ?? 0)/10"
            self?.votesLabel.text = String(movieDetails.voteCount ?? 0)
            self?.overviewView.configureView(with: "Overview", and: movieDetails.overview ?? "No overview")
            let urlString = "https://image.tmdb.org/t/p/w200" + (posterPath)
            let url = URL(string: urlString)!
            self!.imageView.kf.setImage(with: url)
            guard let movidId = self?.movidId else { return }
            group.leave()
        }
        group.enter()
        networkManager.loadCastOfMovie(movieId: movidId) { [weak self] cast in
            cast.forEach { cast in
                self?.cast.append(cast)
            }
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            self?.hideLoader()
            print("All requests completed")
        }
    }
    
    private func createStarsStack(){
        let voteFullStars: Int = voteAvg/2
        let remainOfStars: Int = voteAvg % 2
        for _ in 0..<voteFullStars {
            let fullStar = UIImageView()
            fullStar.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
            fullStar.contentMode = .scaleToFill
            fullStar.image = UIImage(named: "full_star")
            starsStack.addArrangedSubview(fullStar)
        }
        var leftEmptyStars: Int = 5 - voteFullStars
        if remainOfStars > 0 {
            let halfStar = UIImageView()
            halfStar.image = UIImage(named: "half_star")
            halfStar.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
            halfStar.contentMode = .scaleToFill
            starsStack.addArrangedSubview(halfStar)
            leftEmptyStars = leftEmptyStars - 1
        }
        for _ in 0..<leftEmptyStars {
            let emptyStar = UIImageView()
            emptyStar.image = UIImage(named: "empty_star")
            emptyStar.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
            emptyStar.contentMode = .scaleToFill
            starsStack.addArrangedSubview(emptyStar)
        }
    }
    
    @objc private func youTubeTapped(){
        networkManager.loadMovieDetailsVideos(id: movidId) {  videos in
            _ = videos.filter {video in
                if let site = video.webSite {
                    site.contains("YouTube")
                } else {
                    .init()
                }
            }
            guard let key = videos.first?.key else {
                return
            }
            let urlString = "https://www.youtube.com/watch?v=" + key
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc private func imdbTapped(){
        networkManager.loadMovieDetailsExternalIds(id: movidId) { ids in
            guard let id = ids.imdb else {
                return
            }
            let urlString = "https://www.imdb.com/title/" + id
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc private func facebookTapped(){
        networkManager.loadMovieDetailsExternalIds(id: movidId) { ids in
            guard let id = ids.facebook else {
                return
            }
            let urlString = "https://www.facebook.com/" + id
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: CollectionViewDelegate, DataSource
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.genresCollection{
            return genres.count
        }
        else {
            return cast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.castCollection {
            let cell = castCollection.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
            cell.configure(name: cast[indexPath.row].name, role: cast[indexPath.row].character ?? "No info", imagePath: cast[indexPath.row].profilePath ?? "noImage")
            return cell
        }
        else {
            let cell = genresCollection.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
            cell.configure(title: genres[indexPath.row].name, selectedBackgroundColor: .red, unselectedBackgroundColor: .blue)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.genresCollection{
            return CGSize(width: 150, height: 35)
        }
        else {
            return CGSize(width: 200, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.castCollection{
            let actorDetails = ActorDetailsViewController()
            let actor = cast[indexPath.row]
            actorDetails.actorId = actor.id
            navigationController?.pushViewController(actorDetails, animated: true)
        }
    }
}
