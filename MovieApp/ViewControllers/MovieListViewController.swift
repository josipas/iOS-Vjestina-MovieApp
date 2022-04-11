import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    private var searchBar: SearchBarView!
    private var nonFocusTableView: UITableView!
    private var focusTableView: UITableView!

    private let filters = ["What's popular", "Free To Watch", "Trending"]
    private let movies = Movies.all()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
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
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.bottom.equalToSuperview()
        }

        focusTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
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
        if tableView == nonFocusTableView {
            return filters.count
        }
        else {
            return 1
        }
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
            cell.set(title: filters[indexPath.section], filters: ["Action", "Comedy", "Romance", "Action", "Comedy", "Romance"])
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

            cell.set(imageUrl: movie.imageUrl, title: movie.title, description: movie.description)
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
    func getMoviesCount(section: Int) -> Int {
        movies.count
    }

    func getMovieImageUrl(indexPath: IndexPath) -> String {
        return movies[indexPath.row].imageUrl
    }
}
