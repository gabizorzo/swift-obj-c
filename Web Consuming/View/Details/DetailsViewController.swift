import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Movie Service
    let movieService = MovieService()
    
    // MARK: - Movie
    var movie: Movie = Movie()
    
    // MARK: - View did load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        movieService.detailsFor(movie: self.movie)
    }
    
    // MARK: - Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailsTableViewCell
        
        cell.titleLabel.text = movie.title
        cell.genersLabel.text = movie.genres
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        let ratings = formatter.string(for: movie.vote_average)
        cell.ratingsLabel.text = ratings
        
        cell.overviewLabel.text = movie.overview
        movieService.getImage(path: movie.poster_path){ imageApi in
            cell.posterImage.image = imageApi
        }
        
        return cell
    }

}

// MARK: - Extension: Delegate
/* func refreshMovies() from MovieServiceDelegate
    Used to reload the table view once the movie details are updated from the API.
 */
extension DetailsViewController: MovieServiceDelegate {
    func refreshMovies() {
        self.tableView.reloadData()
    }
}
