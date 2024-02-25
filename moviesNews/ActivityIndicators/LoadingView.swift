//
//  LoadingView.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.01.2024.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    private enum Constants {
        static let animationViewSize: CGSize = .init(width: 95, height: 200)
    }
    
    // MARK: Properties
    private let containerView = UIView()
    
    private var isLoading: Bool = false

    private let animationView: AnimationView = {
        let view = AnimationView()
        let animation = Animation.named("loader")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.25
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    private let snowAnimation: AnimationView = {
        let view = AnimationView()
        view.contentMode = .scaleAspectFill
        view.animationSpeed = 1.25
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setupAnimation()
        handleNewYearPeriod()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: Methods
    private func setupAnimation() {
        addSubview(containerView)
        
        containerView.addSubview(animationView)
        containerView.addSubview(snowAnimation)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.animationViewSize)
        }
        
        snowAnimation.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func handleNewYearPeriod() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Almaty")
        
        let newYearDays = UserDefaults.standard.integer(forKey: "isNewYearPeriod")
        let newYearSettedDay = UserDefaults.standard.string(forKey: "newYearSettedDay")
        let currentDay = dateFormatter.string(from: Date())
        
        if newYearDays <= 2 && currentDay != newYearSettedDay {
            UserDefaults.standard.set(newYearDays + 1, forKey: "isNewYearPeriod")
            UserDefaults.standard.set(currentDay, forKey: "newYearSettedDay")
        }
        let finalNewYearDays = UserDefaults.standard.integer(forKey: "isNewYearPeriod")
        if finalNewYearDays <= 2 {
            animationView.animation = Animation.named("newYear")
            snowAnimation.animation = Animation.named("snowfall")
        }
    }
    
    func startLoading(){
        if isLoading {return}
        
        isLoading = true
        
        animationView.play(
            fromProgress: animationView.currentProgress,
            toProgress: 1,
            loopMode: .loop
        )
        snowAnimation.play(
            fromProgress: animationView.currentProgress,
            toProgress: 1,
            loopMode: .loop
        )
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    func stopLoading() {
        isLoading = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.animationView.stop()
        }
    }
}
