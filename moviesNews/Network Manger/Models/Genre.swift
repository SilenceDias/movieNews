//
//  Genre.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import Foundation
struct Genre: Decodable {
    var id: Int
    var name: String
}

struct GenresEntity: Decodable {
    let genres: [Genre]
}
