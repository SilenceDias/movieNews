//
//  ActorsExternalIds.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import Foundation

struct ActorsExternalIds: Codable {
    let id: Int
    let imdbID: String?
    let instagramID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case instagramID = "instagram_id"
    }
}
