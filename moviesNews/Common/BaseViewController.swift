//
//  BaseViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.01.2024.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let animationViewSize: CGSize = .init(width: 40, height: 200)
    }
    
    // MARK: - Properties
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.layer.zPosition = 10
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0
        view.frame = view.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Methods
    private func setupViews(){
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showLoader(){
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.startLoading()
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopLoading()
        }
    }
}
