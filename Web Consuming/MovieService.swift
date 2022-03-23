//
//  MovieService.swift
//  Web Consuming
//
//  Created by Gabriela Zorzo on 23/03/22.
//

import Foundation
import UIKit

protocol MovieServiceDelegate {
    func refreshMovies()
}

class MovieService : NSObject, MovieAPIDelegate {
    var delegate: MovieServiceDelegate?
    
    var movies : [FetchOption : [Movie]] = [
        FetchOption.nowPlaying : [],
        FetchOption.popular : []
    ] {
        didSet {
            delegate?.refreshMovies()
        }
    }
    
    private var movieAPI : MovieAPI
    
    override init() {
        self.movieAPI = MovieAPI()
        super.init()
        self.movieAPI.delegate = self
        self.movieAPI.fetchMovieList(.popular)
        self.movieAPI.fetchMovieList(.nowPlaying)
    }
    
    func detailsFor(movie: Movie) {
        if movie.genres.isEmpty {
            self.movieAPI.fetchMovieDetails(movie)
        }
    }
    
    internal func receivedMovieList(_ json: Data, from option: FetchOption) {
        let error = NSErrorPointer(nilLiteral: ())
        let movies = Parser.movieList(fromJSON: json, error: error)
        
        if error?.pointee != nil || movies.isEmpty {
            print("-X-X- MOVIE LIST ERROR")
            print(error!.pointee!.localizedDescription)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.movies[option] = movies as? [Movie]
        }
    }
    
    internal func receivedMovieDetails(_ json: Data, for movie: Movie) {
        let error = NSErrorPointer(nilLiteral: ())
        Parser.details(for: movie, from: json, error: error)
        delegate?.refreshMovies()
        
        if error?.pointee != nil || movie.genres.isEmpty {
            print("-X-X- MOVIE DETAILS ERROR")
            print(error!.pointee!.localizedDescription)
            return
        }
    }
    
    internal func fetchedFailedWithError(_ error: Error) {
        print("-XXX- FETCH FAILED")
        print(error.localizedDescription)
    }
    
    func getImage(path: URL, completionHandler: @escaping (UIImage) -> Void) {
//        let urlString = "https://image.tmdb.org/t/p/w200/\(path)"
//        let url = URL(string: urlString)!
        var image:UIImage = UIImage(systemName: "clock")!
        URLSession.shared.dataTask(with: path) { (data, response, error) in
            image = UIImage(data: data!) ?? UIImage(systemName: "clock")!
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
        .resume()
    }
}
