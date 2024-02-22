//
//  EmptyStateView.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 15.02.2024.
//

import UIKit

class EmptyStateView: UIView {
    
    private enum Constants {
        static let stackViewSize: CGSize = .init(width: 200, height: 135)
    }
    
    //MARK: UI components
    private var iconImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "error_pic")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 26
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private var boldLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Try to reload page"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setupViews() {
        backgroundColor = .clear
        addSubview(stack)
        [iconImage, boldLabel, label].forEach {
            stack.addArrangedSubview($0)
        }
        
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        boldLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        iconImage.snp.makeConstraints { make in
            make.size.equalTo(Constants.stackViewSize)
        }
    }
    
    func configure(image: String, with title: String, and subtitle: String) {
        self.iconImage.image = UIImage(named: image)
        self.boldLabel.text = title
        self.label.text = subtitle
    }
}
