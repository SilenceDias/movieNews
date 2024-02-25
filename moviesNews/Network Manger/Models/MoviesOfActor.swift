//
//  MoviesOfActor.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import Foundation

struct MoviesOfActor: Codable {
    let cast: [Movies]
    let id: Int
}

// MARK: - Cast
struct Movies: Codable {
    let id: Int
    let posterPath: String?
    let title: String
    let character: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case character
    }
}
