import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Movie Service
    let movieService = MovieService()
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        movieService.delegate = self
    }
    
    // MARK: - Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // MARK: - Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return min(movieService.movies[.popular]!.count,2)
        } else if section == 1 {
            return movieService.movies[.nowPlaying]!.count
        }
        return 0
    }
    
    // MARK: - Title for header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Popular Movies"
        } else if section == 1 {
            return "Now Playing"
        }
        return ""
    }
    
    // MARK: - View for header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                var title: String = ""

                if section == 0 {
                    title = "Popular Movies"

                } else if section == 1 {
                    title = "Now Playing"
                }

                let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))

                header.backgroundColor = .white

                let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 22))

                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

                label.text = title

                header.addSubview(label)

                return header
            }
    
    // MARK: - Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! TableViewCell
            
            let popularMovie = movieService.movies[.popular]![indexPath.row]
            
            cell.titleLabel.text = popularMovie.title
            cell.overviewLabel.text = popularMovie.overview
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            let ratings = formatter.string(for: popularMovie.vote_average)
            cell.ratingsLabel.text = ratings
            
            movieService.getImage(path: popularMovie.poster_path){ imageApi in
                cell.posterImage.image = imageApi
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! TableViewCell
            
            let nowPlaying = movieService.movies[.nowPlaying]![indexPath.row]
            
            cell.titleLabel.text = nowPlaying.title
            cell.overviewLabel.text = nowPlaying.overview
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            let ratings = formatter.string(for: nowPlaying.vote_average)
            cell.ratingsLabel.text = ratings
            
            movieService.getImage(path: nowPlaying.poster_path){ imageApi in
                cell.posterImage.image = imageApi
            }
            
            return cell
        }
    }
    
    // MARK: - Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            performSegue(withIdentifier: "detailsNavigation", sender: movieService.movies[.popular]![indexPath.row])
        } else if indexPath.section == 1{
            performSegue(withIdentifier: "detailsNavigation", sender: movieService.movies[.nowPlaying]![indexPath.row])
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movie = sender as? Movie else { return }
        
        guard let nextViewController = segue.destination as? DetailsViewController else { return }
        nextViewController.movie = movie
    }
}

// MARK: - Extension: Delegate
/* func refreshMovies() from MovieServiceDelegate
    Used to reload the table view once the movie list is updated from the API.
 */
extension ViewController: MovieServiceDelegate {
    func refreshMovies() {
        self.tableView.reloadData()
    }
}
