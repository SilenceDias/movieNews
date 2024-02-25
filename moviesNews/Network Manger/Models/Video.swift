//
//  Video.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 21.12.2023.
//

import Foundation

struct VideoEntity: Decodable {
    var results: [Video]
}

struct Video:Decodable {
    var key: String?
    var webSite: String?
}
