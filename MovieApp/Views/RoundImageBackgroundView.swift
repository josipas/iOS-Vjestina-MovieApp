import UIKit
import SnapKit

protocol RoundImageBackgroundViewDelegate: AnyObject {
    func heartTapped(state: Bool)
}

class RoundImageBackgroundView: UIView {
    private var hexColor: String?
    private var size: Int?

    private var image: UIImage!
    private var imageView: UIImageView!
    private var flag: Bool = false

    weak var delegate: RoundImageBackgroundViewDelegate?

    private let heartImage = UIImage(systemName: "heart")
    private let filledHeartImage = UIImage(systemName: "heart.fill")

    init(imageTitle: String, hexColor: String, size: Int) {
        super.init(frame: .zero)

        image = UIImage(systemName: imageTitle)
        self.hexColor = hexColor
        self.size = size

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(isFavorite: Bool) {
        self.flag = isFavorite
        imageView.image = (flag == false ?  heartImage : filledHeartImage)
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
        addGestures()
    }

    private func createViews() {
        imageView = UIImageView(image: image)
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func styleViews() {
        clipsToBounds = true
        tintColor = .white
        imageView.contentMode = .scaleAspectFit

        guard let hexColor = hexColor else {
            return
        }

        layer.backgroundColor = UIColor(hex: hexColor)?.withAlphaComponent(0.6).cgColor
    }

    private func addConstraints() {
        guard let size = size else {
            return
        }

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.width.equalTo(size)
        }
    }

    private func addGestures() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        self.addGestureRecognizer(recognizer)
    }

    @objc private func heartTapped() {
        flag.toggle()
        imageView.image = (flag == false ?  heartImage : filledHeartImage)
        delegate?.heartTapped(state: flag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.bounds.height / 2
    }
}

