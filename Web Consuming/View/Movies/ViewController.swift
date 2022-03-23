import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        movieService.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return min(movieService.movies[.popular]!.count,2)
        } else if section == 1 {
            return movieService.movies[.nowPlaying]!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Popular Movies"
        } else if section == 1 {
            return "Now Playing"
        }
        return ""
    }
    
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

extension ViewController: MovieServiceDelegate {
    func refreshMovies() {
        self.tableView.reloadData()
    }
}
