import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    private var searchBar: SearchBarView!

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
    }

    private func addSubviews() {
        view.addSubview(searchBar)
    }

    private func styleViews() {
        view.backgroundColor = .white
    }

    private func addConstraints() {
        searchBar.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(22)
        }
    }
}
