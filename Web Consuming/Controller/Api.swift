import Foundation
import UIKit

struct Api {
    func getNowPlaying(page: Int, completionHandler: @escaping ([Movie]) -> Void){
        if page < 0 { fatalError("Page should not be lower than 0") }
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=b7f2a1086e35bdd8073a3001a67fd56f&language=en-US&page=\(page)"
        let url = URL(string: urlString)!
        
        //var movies:[Movie] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            typealias AuxMovies = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let results = dictionary["results"] as? [AuxMovies]
            else {
                completionHandler([])
                return
            }
            
            var movies: [Movie] = []
            
            for moviesDictionary in results {
                guard let id = moviesDictionary["id"] as? Int,
                      let title = moviesDictionary["title"] as? String,
                      let overview = moviesDictionary["overview"] as? String,
                      let poster_path = moviesDictionary["poster_path"] as? String,
                      let vote_average = moviesDictionary["vote_average"] as? Double
                else { continue }
                let movie = Movie(title: title, overview: overview, id: id, vote_average: vote_average, image: poster_path)
                movies.append(movie)
            }
            
            completionHandler(movies)
        }
        .resume()
    }
    
    func getDetails(movieId: Int, completionHandler: @escaping (Movie) -> Void){
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=b7f2a1086e35bdd8073a3001a67fd56f&language=en-US"
        //let urlString = "https://api.themoviedb.org/3/movie/550?api_key=b7f2a1086e35bdd8073a3001a67fd56f&language=en-US"
        let url = URL(string: urlString)!
        
        //var movies:[Movie] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //typealias AuxMovies = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any]
            else {
                completionHandler(Movie())
                return
            }
            //var movie = Movie()
                guard let id = dictionary["id"] as? Int,
                      let title = dictionary["title"] as? String,
                      let overview = dictionary["overview"] as? String,
                      let vote_average = dictionary["vote_average"] as? Double,
                      let poster_path = dictionary["poster_path"] as? String,
                      let genres = dictionary["genres"] as? [[String: Any]] //[Genres]
                else {
                    completionHandler(Movie())
                    return
                }
            let parsedGenres:[Genres] = genres.compactMap(parseGenres(dictionary:))
            let movie  = Movie(title: title, overview: overview, id: id, vote_average: vote_average, genres: parsedGenres, image: poster_path)
            completionHandler(movie)
            }
        .resume()
    }
    
    func parseGenres(dictionary:[String: Any]) -> Genres?{
        guard let id = dictionary["id"] as? Int,
        let name = dictionary["name"] as? String
        else{
            return nil
        }
        return Genres(id: id, name: name)
    }
    
    func getPopular(page: Int, completionHandler: @escaping ([Movie]) -> Void){
        if page < 0 { fatalError("Page should not be lower than 0") }
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=b7f2a1086e35bdd8073a3001a67fd56f&language=en-US&page=\(page)"
        let url = URL(string: urlString)!
        
        //var movies:[Movie] = []
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            typealias AuxMovies = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let results = dictionary["results"] as? [AuxMovies]
            else {
                completionHandler([])
                return
            }
            
            var movies: [Movie] = []
            
            for moviesDictionary in results {
                guard let id = moviesDictionary["id"] as? Int,
                      let title = moviesDictionary["title"] as? String,
                      let overview = moviesDictionary["overview"] as? String,
                      let poster_path = moviesDictionary["poster_path"] as? String,
                      let vote_average = moviesDictionary["vote_average"] as? Double
                else { continue }
                let movie = Movie(title: title, overview: overview, id: id, vote_average: vote_average, image: poster_path)
                movies.append(movie)
            }
            
            completionHandler(movies)
        }
        .resume()
    }
    
    func getImage(path:String, completionHandler: @escaping (UIImage) -> Void) {
        let urlString = "https://image.tmdb.org/t/p/w200/\(path)"
        let url = URL(string: urlString)!
        var image:UIImage = UIImage(systemName: "clock")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            image = UIImage(data: data!) ?? UIImage(systemName: "clock")!
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
        .resume()
    }
}
