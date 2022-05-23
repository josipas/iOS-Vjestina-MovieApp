import UIKit
import MovieAppData

class FavoritesViewController: UIViewController {
    private var navigationBarImageView: UIImageView!
    private var navigationBarImage: UIImage!
    private var favoritesTitle: UILabel!
    private var favoriteMovies: UICollectionView!

    private let movies = MovieAppData.Movies.all()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        buildViews()
        setUpNavBar()
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        favoritesTitle = UILabel()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical

        favoriteMovies = UICollectionView(frame: .zero, collectionViewLayout: layout)
        favoriteMovies.delegate = self
        favoriteMovies.dataSource = self
        favoriteMovies.register(MoviePictureCollectionViewCell.self, forCellWithReuseIdentifier: MoviePictureCollectionViewCell.reuseIdentifier)
    }

    private func addSubviews() {
        view.addSubview(favoritesTitle)
        view.addSubview(favoriteMovies)
    }

    private func styleViews() {
        favoritesTitle.text = "Favorites"
        favoritesTitle.font = .systemFont(ofSize: 20, weight: .bold)
        favoritesTitle.textColor = UIColor(hex: "#0B253F")
    }

    private func addConstraints() {
        favoritesTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(35)
        }

        favoriteMovies.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(favoritesTitle.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePictureCollectionViewCell.reuseIdentifier, for: indexPath) as? MoviePictureCollectionViewCell
        else {
            fatalError()
        }


        let imageUrl = movies[indexPath.row].imageUrl
        cell.set(imageUrl: imageUrl)

        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let peopleCollectionWidth = collectionView.frame.width
        let itemDimension = (peopleCollectionWidth - 2*18) / 3

        return CGSize(width: itemDimension, height: 155)
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
