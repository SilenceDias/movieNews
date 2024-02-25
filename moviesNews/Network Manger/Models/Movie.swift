//
//  Movie.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 11.12.2023.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let page: Int
    let results: [Result]
    enum CodingKeys: String, CodingKey {
        case page, results
    }
}

// MARK: - Result
struct Result: Codable {
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath, releaseDate, title: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


