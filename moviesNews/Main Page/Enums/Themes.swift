//
//  Themes.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 23.12.2023.
//

import Foundation

enum Themes: String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    
    var urlPaths: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        }
    }
    
    var key: String {
        return rawValue
    }
}

