//
//  Actor.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import Foundation

struct Actor: Codable {
    let biography, birthday: String?
    let deathday: String?
    let name, placeOfBirth: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case biography, birthday, deathday
        case name
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
    }
}
