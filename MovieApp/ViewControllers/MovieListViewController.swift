import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    private var searchBar: SearchBarView!
    private var nonFocusTableView: UITableView!
    private var focusTableView: UITableView!
    private var navigationBarImageView: UIImageView!
    private var navigationBarImage: UIImage!
    private let networkService: NetworkingServiceProtocol = NetworkService()

    private var genres: [Genre] = []
    private var popularMovies: [Movie] = []
    private var trendingMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var recommendedMovies: [Movie] = []

    private let networkCheck = NetworkCheck.sharedInstance()
    private let groups: [MovieGroup] = MovieGroup.allCases.filter { $0.description != nil }
    private let movies = Movies.all()

    override func viewDidLoad() {
        super.viewDidLoad()

        if networkCheck.getCurrentStatus() == .satisfied {
            setUpNavBar()
            getData()
            buildViews()

        } else {
            self.view.backgroundColor = .white
            setUpNavBar()
            self.showNoInternetConnectionAlert()
        }
    }

    private func getData() {
        getGenres()
        getMovies(group: .popular)
        getMovies(group: .trending)
        getMovies(group: .topRated)
        getMovies(group: .recommended)
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        searchBar = SearchBarView()
        searchBar.delegate = self

        nonFocusTableView = UITableView()
        nonFocusTableView.delegate = self
        nonFocusTableView.dataSource = self

        focusTableView = UITableView()
        focusTableView.delegate = self
        focusTableView.dataSource = self
    }

    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(nonFocusTableView)
        view.addSubview(focusTableView)
    }

    private func styleViews() {
        view.backgroundColor = .white

        nonFocusTableView.register(MoviesNonFocusTableViewCell.self, forCellReuseIdentifier: MoviesNonFocusTableViewCell.reuseIdentifier)
        nonFocusTableView.separatorStyle = .none

        focusTableView.register(MoviesFocusTableViewCell.self, forCellReuseIdentifier: MoviesFocusTableViewCell.reuseIdentifier)
        focusTableView.separatorStyle = .none
        focusTableView.isHidden = true
    }

    private func addConstraints() {
        searchBar.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(45)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
        }

        nonFocusTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.bottom.equalToSuperview()
        }

        focusTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func setUpNavBar() {
        navigationBarImageView = UIImageView()
        navigationBarImage = UIImage(named: "tmdb")

        navigationBarImageView.frame = CGRect(x: 0, y: 0, width: 145, height: 35)
        navigationBarImageView.image = navigationBarImage

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: "#0B253F")
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationItem.titleView = navigationBarImageView

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", image: nil, primaryAction: nil, menu: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }

    private func getGenres() {
        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        endpoint.path = "/3/genre/movie/list"
        endpoint.queryItems = [URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getGenres(URLRequest(url: url)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let genres):
                self.genres = genres
            case .failure(let error):
                print(error)
            }
        }
    }

    private func getMovies(group: MovieGroup) {
        var endpoint = URLComponents()

        endpoint.scheme = Constants.baseScheme
        endpoint.host = Constants.baseHost
        switch group {
        case .popular:
            endpoint.path = "/3/movie/popular"
        case .trending:
            endpoint.path = "/3/trending/movie/day"
        case .topRated:
            endpoint.path = "/3/movie/top_rated"
        case .recommended:
            endpoint.path = "/3/movie/103/recommendations"
        }

        endpoint.queryItems = [URLQueryItem(name: "language", value: "en-US"), URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "api_key", value: Constants.apiKey)]

        guard
            let endpoint = endpoint.string,
            let url = URL(string: endpoint)
        else {
            return
        }

        networkService.getMovies(URLRequest(url: url)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                switch group {
                case .popular:
                    self.popularMovies = value
                case .trending:
                    self.trendingMovies = value
                case .topRated:
                    self.topRatedMovies = value
                case .recommended:
                    self.recommendedMovies = value
                }
            }
        }
    }

    private func showNoInternetConnectionAlert() {
        let alert = UIAlertController(title: "No internet", message: "Please check your internet connection and try again.",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in

            }))
            self.present(alert, animated: true, completion: nil)
        }
}

extension MovieListViewController: SearchInFocusDelegate {
    func inFocus(bool: Bool) {
        switch bool {
        case true:
            nonFocusTableView.isHidden = true
            focusTableView.isHidden = false
        case false:
            nonFocusTableView.isHidden = false
            focusTableView.isHidden = true
        }
    }
}

extension MovieListViewController: UITableViewDelegate {

}

extension MovieListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard tableView == nonFocusTableView else { return 1 }

        return groups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == nonFocusTableView {
            return 1
        }
        else {
            return movies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == nonFocusTableView {
            guard
                let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: MoviesNonFocusTableViewCell.reuseIdentifier,
                        for: indexPath) as? MoviesNonFocusTableViewCell
            else {
                fatalError()
            }

            cell.delegate = self
            cell.set(genres: genres, group: groups[indexPath.section])
            cell.selectionStyle = .none

            return cell
        } else {
            guard
                let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: MoviesFocusTableViewCell.reuseIdentifier,
                        for: indexPath) as? MoviesFocusTableViewCell
            else {
                fatalError()
            }

            let movie = movies[indexPath.row]

            cell.set(movie: movie)
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == nonFocusTableView {
            return CGFloat(45)
        }
        else {
            return 0
        }
    }
}

extension MovieListViewController: CustomCollectionViewDelegate {
    func getMoviesCount(group: MovieGroup) -> Int {
        switch group {
        case .popular:
            return popularMovies.count
        case .trending:
            return trendingMovies.count
        case .topRated:
            return topRatedMovies.count
        case .recommended:
            return recommendedMovies.count
        }
    }

    func getMovieImageUrl(indexPath: IndexPath, group: MovieGroup) -> String {
        switch group {
        case .popular:
            guard let posterPath = popularMovies[indexPath.row].posterPath else { return ""}
            return "\(Constants.baseUrlForImages)\(posterPath)"
        case .trending:
            guard let posterPath = trendingMovies[indexPath.row].posterPath else { return ""}
            return "\(Constants.baseUrlForImages)\(posterPath)"
        case .topRated:
            guard let posterPath = topRatedMovies[indexPath.row].posterPath else { return ""}
            return "\(Constants.baseUrlForImages)\(posterPath)"
        case .recommended:
            guard let posterPath = recommendedMovies[indexPath.row].posterPath else { return ""}
            return "\(Constants.baseUrlForImages)\(posterPath)"
        }
    }

    func didTapMovie(group: MovieGroup, indexPath: IndexPath) {
        var movieId: String? = nil

        switch group {
        case .popular:
            movieId = String(popularMovies[indexPath.row].id)
        case .trending:
            movieId = String(trendingMovies[indexPath.row].id)
        case .topRated:
            movieId = String(topRatedMovies[indexPath.row].id)
        case .recommended:
            movieId = String(recommendedMovies[indexPath.row].id)
        }

        guard let movieId = movieId else { return }

        navigationController?.pushViewController(MovieDetailsViewController(id: movieId), animated: true)
    }
}
