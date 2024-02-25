//
//  APIResult.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 25.01.2024.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError {
    case networkFail
    case unknown
    case incorrectJson
    case failedWith(reason: String)
}
