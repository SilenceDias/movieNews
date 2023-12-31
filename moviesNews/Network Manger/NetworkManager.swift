//
//  NetworkManager.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 20.12.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static var shared = NetworkManager()
    private let urlString: String = "https://api.themoviedb.org"
    private let apiKey: String = "d568b1ed6289cb2eb4c00ca0e87771ee"
    private let session = URLSession(configuration: .default)
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    func loadMovieLists(filter: String, completion: @escaping([Result]) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(filter)"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
            guard let data = response.data else {
                print("Error: did not get Data")
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
        components.path = "/3/movie/\(movieId)/casts"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/genre/movie/list"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/movie/\(id)/videos"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/movie/\(id)/external_ids"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/person/\(id)"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/person/\(id)/images"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/person/\(id)/movie_credits"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
        components.path = "/3/person/\(id)/external_ids"
        guard let requestUrl = components.url else {
            return
        }
        AF.request(requestUrl).responseJSON { response in
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
    
}
