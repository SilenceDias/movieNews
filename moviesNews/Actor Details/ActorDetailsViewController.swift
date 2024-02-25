//
//  ActorDetailsViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class ActorDetailsViewController: BaseViewController {
    // MARK: Properties
    var actorId = Int()
    
    private var networkManager = NetworkManager.shared
    private var allPhotosCount = Int()
    private var lastPhotoIndex = Int()
    
    private lazy var photos:[Profile] = [] {
        didSet{
            self.photosOfActorCollection.reloadData()
        }
    }
    
    private lazy var movies:[Movies] = [] {
        didSet{
            self.moviesCollection.reloadData()
        }
    }
    
    // MARK: UI Components
    private var imageView = UIImageView()
    private var biographyView = CustomOverview()
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInset = .zero
        return scroll
    }()
    
    private var contentView = UIView()
    
    private var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private var bornLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private var placeOfBornLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private var deathLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var photosOfActorCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(ActorPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "ActorPhotosCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var photosLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Photos"
        view.numberOfLines = 0
        return view
    }()
    
    private var moviesLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Movies"
        view.numberOfLines = 0
        return view
    }()
    
    private var linkLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.text = "Links"
        view.numberOfLines = 0
        return view
    }()
    
    private let imdbImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "imdb")
        return image
    }()
    
    private let instagramImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "instagram")
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
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: Methods
    private func setupViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.backgroundColor = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        [imageView, nameLabel, bornLabel, placeOfBornLabel, deathLabel, biographyView, photosOfActorCollection, moviesCollection, photosLabel, moviesLabel, linkLabel, socialMediasStack].forEach {
            contentView.addSubview($0)
        }
        [imdbImage, instagramImage].forEach {
            socialMediasStack.addArrangedSubview($0)
        }
        imageView.snp.makeConstraints {make in
            make.height.equalTo(425)
            make.width.equalTo(325)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        bornLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        placeOfBornLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bornLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        deathLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeOfBornLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        biographyView.snp.makeConstraints { make in
            make.top.equalTo(deathLabel.snp.bottom).offset(8)
            make.right.left.equalToSuperview()
        }
        photosLabel.snp.makeConstraints { make in
            make.top.equalTo(biographyView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        photosOfActorCollection.snp.makeConstraints { make in
            make.top.equalTo(photosLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        moviesLabel.snp.makeConstraints { make in
            make.top.equalTo(photosOfActorCollection.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        moviesCollection.snp.makeConstraints { make in
            make.top.equalTo(moviesLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(moviesCollection.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        socialMediasStack.snp.makeConstraints { make in
            make.top.equalTo(linkLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        let tapGRImdb = UITapGestureRecognizer(target: self, action: #selector(self.imdbTapped))
        imdbImage.addGestureRecognizer(tapGRImdb)
        imdbImage.isUserInteractionEnabled = true
        let tapGRInsta = UITapGestureRecognizer(target: self, action: #selector(self.instagramTapped))
        instagramImage.addGestureRecognizer(tapGRInsta)
        instagramImage.isUserInteractionEnabled = true
    }
    
    private func loadData(){
        showLoader()
        let group = DispatchGroup()
        group.enter()
        networkManager.loadCastDetails(id: actorId) { [weak self] actorDetails in
            guard let posterPath = actorDetails.profilePath else{return}
            let urlString = "https://image.tmdb.org/t/p/w200" + (posterPath)
            let url = URL(string: urlString)!
            self!.imageView.kf.setImage(with: url)
            self?.bornLabel.text = "Born: \(actorDetails.birthday ?? "No info")"
            self?.nameLabel.text = actorDetails.name
            self?.title = actorDetails.name
            self?.placeOfBornLabel.text = actorDetails.placeOfBirth
            self?.deathLabel.text = "Death: \(actorDetails.deathday ?? "Alive")"
            self?.biographyView.configureView(with: "Biography", and: actorDetails.biography ?? "No bio yet")
            group.leave()
        }
        group.enter()
        networkManager.loadPhotosOfActor(id: actorId) {[weak self] photos in
            if photos.count > 4 {
                for i in 0...3 {
                    self?.photos.append(photos[i])
                }
                self?.lastPhotoIndex = 3
            }
            else {
                for i in 0...(photos.count-1){
                    self?.photos.append(photos[i])
                }
                self?.lastPhotoIndex = photos.count - 1
            }
            self?.allPhotosCount = photos.count
            group.leave()
        }
        group.enter()
        networkManager.loadMoviesOfActor(id: actorId) { [weak self] movies in
            movies.forEach { movie in
                self?.movies.append(movie)
            }
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            self?.hideLoader()
            print("All requests completed")
        }
    }
    
    @objc func imdbTapped(){
        networkManager.loadActorsExternalIds(id: actorId) { ids in
            guard let id = ids.imdbID else {
                return
            }
            let urlString = "https://www.imdb.com/name/" + id
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func instagramTapped(){
        networkManager.loadActorsExternalIds(id: actorId) { ids in
            guard let id = ids.instagramID else {
                return
            }
            let urlString = "https://www.instagram.com/" + id
            if let url = URL(string: urlString){
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: CollectionViewDelegate, DataSource
extension ActorDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photosOfActorCollection{
            return photos.count
        }
        else {
            return movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == photosOfActorCollection{
            let cell = photosOfActorCollection.dequeueReusableCell(withReuseIdentifier: "ActorPhotosCollectionViewCell", for: indexPath) as! ActorPhotosCollectionViewCell
            if allPhotosCount > 4 {
                if indexPath.row != 3 {
                    cell.configure(plus: "", imagePath: photos[indexPath.row].filePath, alpha: 1.0)
                }
                else {
                    cell.configure(plus: "+\(allPhotosCount - 4)", imagePath: photos[indexPath.row].filePath, alpha: 0.5)
                }
            }
            else {
                cell.configure(plus: "", imagePath: photos[indexPath.row].filePath, alpha: 1.0)
            }
            return cell
        }
        else {
            let cell = moviesCollection.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
            cell.configure(name: movies[indexPath.row].title, role: movies[indexPath.row].character ?? "No info", imagePath: movies[indexPath.row].posterPath ?? "noImage")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photosOfActorCollection{
            return CGSize(width: 80, height: 150)
        }
        else {
            return CGSize(width: 200, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == photosOfActorCollection {
            let gallery = GalleryViewController()
            gallery.actorId = actorId
            gallery.allPhotosCount = allPhotosCount
            gallery.indexOfShownPhoto = indexPath
            navigationController?.pushViewController(gallery, animated: true)
        }
    }
}
