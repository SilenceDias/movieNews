//
//  NetworkManager.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class NetworkManager {
    static var shared = NetworkManager()
    private let urlString: String = "https://api.themoviedb.org"
    private var apiKey: String? = KeychainWrapper.standard.string(forKey: "SessionId")
    private let session = URLSession(configuration: .default)
    private var isLoggedIn = false
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    private let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNTY4YjFlZDYyODljYjJlYjRjMDBjYTBlODc3NzFlZSIsInN1YiI6IjY1NzZhN2Q5YTg0YTQ3MmRlMmVlYTdlMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zzAgW4aI2oJFRgESaA1HVSv3ZKKQnEYm2I1zZwiouQs"
    ]
    
    func loadMovieLists(filter: String, completion: @escaping([Result]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/movie/\(filter)"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                print(components.url!)
                return
            }
            do{
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    completion(movie.results)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func loadCastOfMovie(movieId:Int, completion: @escaping([CastElement]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/movie/\(movieId)/casts"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let cast = try JSONDecoder().decode(Cast.self, from: data)
                DispatchQueue.main.async {
                    completion(cast.cast)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func loadGenres(completion: @escaping([Genre]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/genre/movie/list"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let genres = try JSONDecoder().decode(GenresEntity.self, from: data)
                DispatchQueue.main.async {
                    completion(genres.genres)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadMovieDetails(id: Int, completion: @escaping(MovieDetails) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(id)"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                DispatchQueue.main.async {
                    completion(movieDetails)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadMovieDetailsVideos(id: Int, completion: @escaping([Video]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/movie/\(id)/videos"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let video = try JSONDecoder().decode(VideoEntity.self, from: data)
                DispatchQueue.main.async {
                    completion(video.results)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func loadMovieDetailsExternalIds(id: Int, completion: @escaping(ExterndalIds) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/movie/\(id)/external_ids"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let externalIds = try JSONDecoder().decode(ExterndalIds.self, from: data)
                DispatchQueue.main.async {
                    completion(externalIds)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadCastDetails(id: Int, completion: @escaping(Actor) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/person/\(id)"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let actorDetails = try JSONDecoder().decode(Actor.self, from: data)
                DispatchQueue.main.async {
                    completion(actorDetails)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadPhotosOfActor(id: Int, completion: @escaping([Profile]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/person/\(id)/images"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let photos = try JSONDecoder().decode(Photos.self, from: data)
                DispatchQueue.main.async {
                    completion(photos.profiles)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadMoviesOfActor(id: Int, completion: @escaping([Movies]) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/person/\(id)/movie_credits"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let movies = try JSONDecoder().decode(MoviesOfActor.self, from: data)
                DispatchQueue.main.async {
                    completion(movies.cast)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func loadActorsExternalIds(id: Int, completion: @escaping(ActorsExternalIds) -> Void){
        var components = urlComponents
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        components.path = "/3/person/\(id)/external_ids"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl, headers: headers).responseData { response in
            guard let data = response.data else {
                print("Error: did not get Data")
                return
            }
            do{
                let externalIds = try JSONDecoder().decode(ActorsExternalIds.self, from: data)
                DispatchQueue.main.async {
                    completion(externalIds)
                }
            } catch {
                DispatchQueue.main.async {
                    print("No json!")
                }
            }
        }
    }
    
    func getRequestToken(completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
        var components = urlComponents
        components.path = "/3/authentication/token/new"
        components.queryItems = nil
        
        guard let requestUrl = components.url else {
            completion(.failure(.unknown))
            return
        }
        
        AF.request(requestUrl, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print(response)
                do {
                    let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
                    completion(.success(requestTokenModel))
                } catch {
                    completion(.failure(.incorrectJson))
                }
            case .failure:
                completion(.failure(.unknown))
            }
        }
    }
    
    func validateWithLogin(requestBody: [String: Any], completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
        var components = urlComponents
        components.path = "/3/authentication/token/validate_with_login"
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "application/json"
        
        guard let requestUrl = components.url else {
            completion(.failure(.unknown))
            return
        }
        
        AF.request(
            requestUrl,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default,
            headers: requestHeaders
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
                    completion(.success(requestTokenModel))
                } catch {
                    completion(.failure(.incorrectJson))
                }
            case .failure:
                completion(.failure(.unknown))
            }
        }
    }
    
    func createSession(requestBody: [String: Any], completion: @escaping (APIResult<String>) -> Void) {
        var components = urlComponents
        components.path = "/3/authentication/session/new"
        
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "application/json"
        
        guard let requestUrl = components.url else {
            completion(.failure(.unknown))
            return
        }
        
        AF.request(
            requestUrl,
            method: .post,
            parameters: requestBody,
            encoding: JSONEncoding.default,
            headers: requestHeaders
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if
                        let responseData = try JSONSerialization.jsonObject(
                            with: data,
                            options: []
                        ) as? [String: Any],
                        let success = responseData["success"] as? Bool,
                        success,
                        let sessionId = responseData["session_id"] as? String
                    {
                        KeychainWrapper.standard.set(sessionId, forKey: "SessionId")
                        self.apiKey = KeychainWrapper.standard.string(forKey: "SessionId")
                        self.urlComponents.queryItems = [
                            URLQueryItem(name: "api_key", value: self.apiKey)
                        ]
                        self.isLoggedIn = true
                        UserDefaults.standard.set(self.isLoggedIn, forKey: "isLoggedIn")
                        completion(.success(sessionId))
                    } else {
                        completion(.failure(.failedWith(reason: "Failed to create session")))
                    }
                } catch {
                    completion(.failure(.incorrectJson))
                }
            case .failure:
                completion(.failure(.unknown))
            }
        }
    }
}
