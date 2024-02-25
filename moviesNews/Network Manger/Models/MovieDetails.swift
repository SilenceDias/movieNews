//
//  MovieDetails.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import Foundation

struct MovieDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case genres
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case overview = "overview"
    }

    let originalTitle: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let posterPath: String?
    let overview: String?
    let genres: [Genre]
}
