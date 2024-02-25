//
//  Photos.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import Foundation

// MARK: - Cast
struct Photos: Codable {
    let id: Int
    let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
