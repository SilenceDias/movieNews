//
//  MovieTableViewCell.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import UIKit
import Kingfisher
class MovieTableViewCell: UITableViewCell {

    var imageMovie: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        return view
    }()
    var labelMovie: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    var dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    var ratingLabel: UILabel = {
        let view = UILabel()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGreen
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .center
        return view
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, image: String, date: String, rating: Double){
        labelMovie.text = title
        dateLabel.text = date
        ratingLabel.text = "★ \(rating)"
        let urlString = "https://image.tmdb.org/t/p/w200" + (image)
       
        let url = URL(string: urlString)!
        imageMovie.kf.setImage(with: url)

    }
    private func setupViews() {
        self.backgroundColor = .clear
        
        [imageMovie, labelMovie, dateLabel, ratingLabel].forEach {
            contentView.addSubview($0)
        }
        
        imageMovie.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        labelMovie.snp.makeConstraints { make in
            make.top.equalTo(imageMovie.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        dateLabel.snp.makeConstraints({ make in
            make.top.equalTo(labelMovie.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
        })
        ratingLabel.snp.makeConstraints({make in
            make.top.equalTo(imageMovie.snp.top).offset(8)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.left.equalTo(imageMovie.snp.left).offset(8)
        })
    }
}
