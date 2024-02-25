//
//  GalleryCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    private var profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(imagePath: String){
        if imagePath != "noImage"{
            let urlString = "https://image.tmdb.org/t/p/w200" + (imagePath)
            let url = URL(string: urlString)!
            profileImage.kf.setImage(with: url)
        }
        else {
            profileImage.image = UIImage(named: "noProfile")
        }
    }
    
    private func setupViews(){
        [profileImage].forEach {
            contentView.addSubview($0)
        }
        profileImage.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
}
