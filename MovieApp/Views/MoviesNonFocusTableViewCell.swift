import UIKit
import MovieAppData

protocol CustomCollectionViewDelegate: AnyObject {
    func getMoviesCount(group: MovieGroupConst) -> Int
    func getMovie(indexPath: IndexPath, group: MovieGroupConst) -> MovieViewModel
    func didTapMovie(group: MovieGroupConst, indexPath: IndexPath)
    func heartTapped(movieId: Int, state: Bool)
}

class MoviesNonFocusTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MoviesNonFocusTableViewCell.self)

    private var titleLabel: UILabel!
    private var selectionView: CustomSegmentedControl!
    private var collectionView: UICollectionView!

    private var group: MovieGroupConst?

    weak var delegate: CustomCollectionViewDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        self.group = nil
    }

    func set(genres: [MovieGenreViewModel], group: MovieGroupConst) {
        titleLabel.text = group.description
        self.group = group
        genres.forEach({ genre in
            let view = SegmentView(title: genre.name)
            view.delegate = self
            selectionView.addArrangedSubview(view)
        })
        collectionView.reloadData()
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
    }

    private func createViews() {
        titleLabel = UILabel()

        selectionView = CustomSegmentedControl()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoviePictureCollectionViewCell.self, forCellWithReuseIdentifier: MoviePictureCollectionViewCell.reuseIdentifier)
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(selectionView)
        addSubview(collectionView)
    }

    private func styleViews() {
        titleLabel.textColor =  UIColor(hex: "#0B253F")
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }

    private func addContraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(30)
        }

        selectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(30)
        }

        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalTo(selectionView.snp.bottom).offset(25)
            $0.height.equalTo(180)
        }
    }
}

extension MoviesNonFocusTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let group = group else { return }
        delegate?.didTapMovie(group: group, indexPath: indexPath)
    }
}

extension MoviesNonFocusTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = group else { return 0 }
        return delegate?.getMoviesCount(group: group) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePictureCollectionViewCell.reuseIdentifier, for: indexPath) as? MoviePictureCollectionViewCell
        else {
            fatalError()
        }

        if
            let group = group,
            let movie = delegate?.getMovie(indexPath: indexPath, group: group),
            let imageUrl = movie.posterPath
        {
            cell.set(imageUrl: "\(Constants.baseUrlForImages)\(imageUrl)", movieId: movie.id, isFavorite: movie.isFavorite)
            cell.delegate = self
        }

        return cell
    }
}

extension MoviesNonFocusTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 120, height: 180)
    }
}

extension MoviesNonFocusTableViewCell: SegmentDelegate {
    func segmentTapped(view: SegmentView) {
        selectionView.reloadData(view: view)
    }
}

extension UITableViewCell {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
}

extension MoviesNonFocusTableViewCell: MoviePictureCollectionViewCellDelegate {
    func heartTapped(movieId: Int, state: Bool) {
        delegate?.heartTapped(movieId: movieId, state: state)
    }
}
