//
//  ExterndalIds.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.12.2023.
//

import Foundation

struct ExterndalIds: Decodable {
    var imdb: String?
    var facebook: String?
    
    enum CodingKeys: String, CodingKey {
        case imdb = "imdb_id"
        case facebook = "facebook_id"
    }
}
