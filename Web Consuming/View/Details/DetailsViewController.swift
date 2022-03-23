import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let movieService = MovieService()
    
    var movie: Movie = Movie()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        movieService.detailsFor(movie: self.movie)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
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

extension DetailsViewController: MovieServiceDelegate {
    func refreshMovies() {
        self.tableView.reloadData()
    }
}
