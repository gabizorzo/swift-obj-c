//
//  MovieService.swift
//  Web Consuming
//
//  Created by Gabriela Zorzo on 23/03/22.
//

import Foundation
import UIKit

// MARK: - Movie Service Delegate
/* func refreshMovies() for reloading the views when there's a data update
 */
protocol MovieServiceDelegate {
    func refreshMovies()
}

// MARK: - Movie Service
/* Class responsible for integrating the New code (Swift) with the Legacy code (Obj-C)
 */
class MovieService : NSObject, MovieAPIDelegate {
    var delegate: MovieServiceDelegate?
    
    // MARK: - Movies array
    var movies : [FetchOption : [Movie]] = [
        FetchOption.nowPlaying : [],
        FetchOption.popular : []
    ] {
        didSet {
            delegate?.refreshMovies()
        }
    }
    
    // MARK: - Movie API
    /* From the Legacy code */
    private var movieAPI : MovieAPI
    
    override init() {
        self.movieAPI = MovieAPI()
        super.init()
        self.movieAPI.delegate = self
        self.movieAPI.fetchMovieList(.popular)
        self.movieAPI.fetchMovieList(.nowPlaying)
    }
    
    // MARK: - Details for Movie
    /* Responsible for calling the MovieAPI Legacy code and getting the movie details.
        Enter: Movie
        Return: Void
     */
    func detailsFor(movie: Movie) {
        if movie.genres.isEmpty {
            self.movieAPI.fetchMovieDetails(movie)
        }
    }
    
    // MARK: - Received Movie List
    /* From the MovieAPIDelegate
     Enter: JSON, Movie
     Return: Void (var movies has a did set that will call the delegate)
     */
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
    
    // MARK: - Received Movie Details
    /* From the MovieAPIDelegate
        Enter: JSON, Movie
        Return: Void (delegate)
     */
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
    
    // MARK: - Fetched Failed with Error
    /* From the MovieAPIDelegate */
    internal func fetchedFailedWithError(_ error: Error) {
        print("-XXX- FETCH FAILED")
        print(error.localizedDescription)
    }
    
    // MARK: - Get Image
    /* Responsible for getting the post image from the poster_path
        Enter: URL
        Return: Void (completionHandler @escaping(UIImage))
     */
    func getImage(path: URL, completionHandler: @escaping (UIImage) -> Void) {
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
