//
//  Cast.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 24.12.2023.
//

import Foundation

// MARK: - Cast
struct Cast: Codable {
    let id: Int
    let cast, crew: [CastElement]
}

// MARK: - CastElement
struct CastElement: Codable {
    let id: Int
    let name, originalName: String
    let profilePath: String?
    let castID: Int?
    let character: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
    }
}


