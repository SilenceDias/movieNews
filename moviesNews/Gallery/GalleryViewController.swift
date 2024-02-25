//
//  GalleryViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class GalleryViewController: UIViewController {
    
    // MARK: Properties
    var actorId = Int()
    var allPhotosCount = Int()
    var indexOfShownPhoto = IndexPath()
    
    private var networkManager = NetworkManager.shared
    
    private lazy var photos:[Profile] = [] {
        didSet{
            self.galleryCollection.reloadData()
        }
    }
    
    // MARK: UI Components
    private lazy var galleryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "GalleryCollectionViewCell")
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
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let xBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(xButtonClick))
        self.navigationItem.rightBarButtonItem = xBarButton
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.galleryCollection.scrollToItem(at: indexOfShownPhoto, at: .top, animated: true)
    }
    
    // MARK: Methods
    private func setupViews(){
        self.title = "\(indexOfShownPhoto.row + 1)/\(allPhotosCount)"
        view.backgroundColor = .black
        view.addSubview(galleryCollection)
        galleryCollection.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadData(){
        networkManager.loadPhotosOfActor(id: actorId) { [weak self] photos in
            photos.forEach { photo in
                self?.photos.append(photo)
            }
        }
    }
    
    @objc private func xButtonClick(){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: CollectionViewDelegate, DataSource
extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.configure(imagePath: photos[indexPath.row].filePath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
// MARK: UIScrollViewDelegate
extension GalleryViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
            if let lastIndexPath = visibleIndexPaths.last {
                self.title = "\(lastIndexPath.row + 1)/\(allPhotosCount)"
            }
        }
    }
    
}
