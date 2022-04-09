import UIKit

class MoviePictureCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MoviePictureCollectionViewCell.self)

    private var image: UIImage!
    private var imageView: UIImageView!
    private var heartView: RoundImageBackgroundView!
    private var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: .zero)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        //imageView.image = nil
    }

    func set(imageUrl: String) {
        imageView.load(url: URL(fileURLWithPath: imageUrl))
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
    }

    private func createViews() {
        imageView = UIImageView(image: UIImage(named: "ironman"))
        heartView = RoundImageBackgroundView(imageTitle: "heart", hexColor: "#0B253F", size: 18)
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(heartView)
    }

    private func styleViews() {
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }

    private func addContraints() {
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }

        heartView.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.top.leading.equalToSuperview().inset(10)
        }
    }
}
