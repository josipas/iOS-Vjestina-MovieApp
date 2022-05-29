import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    private var searchBar: SearchBarView!
    private var nonFocusTableView: UITableView!
    private var focusTableView: UITableView!
    private var navigationBarImageView: UIImageView!
    private var navigationBarImage: UIImage!

    private var genres: [MovieGenreViewModel] = []
    private var popularMovies: [MovieViewModel] = []
    private var trendingMovies: [MovieViewModel] = []
    private var topRatedMovies: [MovieViewModel] = []
    private var recommendedMovies: [MovieViewModel] = []
    private var searchMovies: [MovieViewModel] = []

    private let networkMonitor = NetworkMonitor()
    private let groups: [MovieGroupConst] = MovieGroupConst.allCases.filter { $0.description != nil }
    private var movieRepository: MovieRepository!

    init(movieRepository: MovieRepository) {
        super.init(nibName: nil, bundle: nil)

        self.movieRepository = movieRepository
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        networkMonitor.startMonitoring(connected: {
            DispatchQueue.main.async {
                self.setUpNavBar()
                self.buildViews()
                self.getDataFromDatabase()
                self.updateDatabase()
            }
        }, unconnected: {
            DispatchQueue.main.async {
                self.buildViews()
                self.setUpNavBar()
                self.getDataFromDatabase()
                self.showNoInternetConnectionAlert()
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getDataFromDatabase()

        DispatchQueue.main.async {
            self.nonFocusTableView.reloadData()
        }
    }

    private func getDataFromDatabase() {
        popularMovies = movieRepository.fetchMoviesFromDatabase(inMovieGroup: .popular)

        trendingMovies = movieRepository.fetchMoviesFromDatabase(inMovieGroup: .trending)

        topRatedMovies = movieRepository.fetchMoviesFromDatabase(inMovieGroup: .topRated)

        recommendedMovies = movieRepository.fetchMoviesFromDatabase(inMovieGroup: .recommended)

        genres = movieRepository.fetchGenresFromDatabase()
    }

    private func updateDatabase() {
        movieRepository.saveGroupsToDatabase(groups: groups)

        movieRepository.getGenresFromNetwork { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.movieRepository.saveGenresToDatabase(genres: genres)
                    self.genres = self.movieRepository.fetchGenresFromDatabase()
                }
            case .failure(let error):
                print(error)
            }
        }

        movieRepository.getMoviesFromNetwork { [weak self] result, group in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print(error)
            case .success(let value):
                switch group {
                case .popular:
                    DispatchQueue.main.async {
                        self.movieRepository.saveMoviesToDatabase(movies: value, group: .popular)
                    }

                case .trending:
                    DispatchQueue.main.async {
                        self.movieRepository.saveMoviesToDatabase(movies: value, group: .trending)
                    }

                case .topRated:
                    DispatchQueue.main.async {
                        self.movieRepository.saveMoviesToDatabase(movies: value, group: .topRated)
                    }

                case .recommended:
                    DispatchQueue.main.async {
                        self.movieRepository.saveMoviesToDatabase(movies: value, group: .recommended)
                    }
                }
            }

            DispatchQueue.main.async {
                self.getDataFromDatabase()
                self.nonFocusTableView.reloadData()
            }
        }
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
        overrideUserInterfaceStyle = .light

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

    private func pushMovieDetails(movieId: String) {
        navigationController?.pushViewController(MovieDetailsViewController(id: movieId, movieRepository: movieRepository), animated: true)
    }

    private func showNoInternetConnectionAlert() {
        let alert = UIAlertController(title: "No internet", message: "Please check your internet connection.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in

        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MovieListViewController: SearchInFocusDelegate {
    func textChanged(text: String) {
        searchMovies = movieRepository.fetchMoviesFromDatabase(text: text)
        focusTableView.reloadData()
    }

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

extension MovieListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard tableView == nonFocusTableView else { return 1 }

        return groups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == nonFocusTableView {
            return 1
        }
        else {
            return searchMovies.count
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

            let movie = searchMovies[indexPath.row]

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == focusTableView {
            let movieId = String(searchMovies[indexPath.row].id)
            self.pushMovieDetails(movieId: movieId)
        }
    }
}

extension MovieListViewController: CustomCollectionViewDelegate {
    func heartTapped(movieId: Int, state: Bool) {
        movieRepository.updateMovieInDatabase(movieId: movieId, isFavorite: state)
    }

    func getMoviesCount(group: MovieGroupConst) -> Int {
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

    func getMovie(indexPath: IndexPath, group: MovieGroupConst) -> MovieViewModel {
        switch group {
        case .popular:
            return popularMovies[indexPath.row]
        case .trending:
            return trendingMovies[indexPath.row]
        case .topRated:
            return topRatedMovies[indexPath.row]
        case .recommended:
            return recommendedMovies[indexPath.row]
        }
    }

    func didTapMovie(group: MovieGroupConst, indexPath: IndexPath) {
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

        self.pushMovieDetails(movieId: movieId)
    }
}
