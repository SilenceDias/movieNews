//
//  CastCollectionViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 24.12.2023.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    private var profileImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }()
    
    private var roleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textAlignment = .center
        view.textColor = .lightGray
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
    func configure(name: String, role: String, imagePath: String){
        nameLabel.text = name
        roleLabel.text = role
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
        [profileImage, nameLabel, roleLabel].forEach {
            contentView.addSubview($0)
        }
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.left.equalToSuperview().offset(4)
            make.top.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.top.right.equalToSuperview().offset(8)
        }
        roleLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.right.equalToSuperview().offset(8)
        }
    }
    
}
    
    
    
 
