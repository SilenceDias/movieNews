//
//  ActorPhotosCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import UIKit

class ActorPhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    private var profileImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var plusLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
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
    func configure(plus: String, imagePath: String, alpha: Double){
        plusLabel.text = plus
        if imagePath != "noImage"{
            let urlString = "https://image.tmdb.org/t/p/w200" + (imagePath)
            let url = URL(string: urlString)!
            profileImage.kf.setImage(with: url)
        }
        else {
            profileImage.image = UIImage(named: "noProfile")
        }
        profileImage.alpha = alpha
    }
    
    private func setupViews(){
        [profileImage, plusLabel].forEach {
            contentView.addSubview($0)
        }
        profileImage.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(60)
            make.left.right.equalToSuperview().offset(4)
            make.top.bottom.equalToSuperview()
        }
        plusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
  
}
