import UIKit

class MovieDetailsViewController: UIViewController {
    private var overviewLabel: UILabel!
    private var overviewDescription: UILabel!
    private var peopleCollection: UICollectionView!
    private var imageView: OverlayImageView!

    private let data = [
        ("Don Heck", "Characters"),
        ("Jack Kirby", "Characters"),
        ("Jon Favreau", "Director"),
        ("Don Heck", "Screenplay"),
        ("Jack Marcum", "Screenplay"),
        ("Matt Holloway", "Screenplay"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        buildViews()
    }

    private func buildViews() {
        createViews()
        addSubviews()
        configureViews()
    }

    private func createViews() {
        overviewLabel = UILabel()
        overviewDescription = UILabel()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        peopleCollection = UICollectionView(frame:
                                                CGRect(
                                                    x: 0,
                                                    y: 0,
                                                    width: (view.bounds.width),
                                                    height: 350),
                                            collectionViewLayout: flowLayout)
        peopleCollection.register(TitleSubtitleCell.self, forCellWithReuseIdentifier: TitleSubtitleCell.reuseIdentifier)
        peopleCollection.delegate = self
        peopleCollection.dataSource = self

        imageView = OverlayImageView(imageTitle: "ironman", title: "Iron Man", year: "(2008)", date: "05/02/2008 (US)", genres: "Action, Science Fiction, Adventure", duration: "2h 6m")
    }

    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(overviewLabel)
        view.addSubview(overviewDescription)
        view.addSubview(peopleCollection)
    }

    private func configureViews() {
        styleViews()
        addConstraints()
    }

    private func styleViews() {
        overviewLabel.text = "Overview"
        overviewLabel.font = .systemFont(ofSize: 20, weight: .bold)
        overviewLabel.textColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)

        overviewDescription.text = "After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil."
        overviewDescription.font = .systemFont(ofSize: 14, weight: .regular)
        overviewDescription.numberOfLines = 0
    }

    private func addConstraints() {
        imageView.snp.makeConstraints {
            $0.height.equalTo(303)
            $0.trailing.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        overviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }

        overviewDescription.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-27)
            $0.top.equalTo(overviewLabel.snp.bottom).offset(8)
        }

        peopleCollection.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(overviewDescription.snp.bottom).offset(22)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {

}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = peopleCollection.dequeueReusableCell(withReuseIdentifier: TitleSubtitleCell.reuseIdentifier,
                                                        for: indexPath) as! TitleSubtitleCell
        cell.configure(title: data[indexPath.row].0, subtitle: data[indexPath.row].1)
        return cell
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let peopleCollectionWidth = peopleCollection.frame.width
        let itemDimension = (peopleCollectionWidth - 2*10) / 3

        return CGSize(width: itemDimension, height: 50)
    }
}
