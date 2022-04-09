import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    private var searchBar: SearchBarView!
    private var nonFocusTableView: UITableView!

    private let filters = ["What's popular", "Free To Watch", "Trending"]

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
    }

    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(nonFocusTableView)
    }

    private func styleViews() {
        view.backgroundColor = .white

        nonFocusTableView.register(MoviesNonFocusTableViewCell.self, forCellReuseIdentifier: MoviesNonFocusTableViewCell.reuseIdentifier)
        nonFocusTableView.separatorStyle = .none
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
    }
}

extension MovieListViewController: SearchInFocusDelegate {
    func inFocus(bool: Bool) {
        switch bool {
        case true:
            nonFocusTableView.isHidden = true
        case false:
            nonFocusTableView.isHidden = false
        }
    }
}

extension MovieListViewController: UITableViewDelegate {

}

extension MovieListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: MoviesNonFocusTableViewCell.reuseIdentifier,
                    for: indexPath) as? MoviesNonFocusTableViewCell
        else {
            fatalError()
        }

        cell.delegate = self
        cell.set(title: filters[indexPath.section])

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat(45)
    }
}

extension MovieListViewController: CustomCollectionViewDelegate {
    func getMoviesCount(section: Int) -> Int {
        Movies.all().count
    }

    func getMovieImageUrl(indexPath: IndexPath) -> String {
        return Movies.all()[indexPath.row].imageUrl
    }
}
