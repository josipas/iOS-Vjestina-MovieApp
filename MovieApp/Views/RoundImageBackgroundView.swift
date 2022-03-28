import UIKit
import SnapKit

class RoundImageBackgroundView: UIView {
    private var image: UIImage!
    private var imageView: UIImageView!

    init(imageTitle: String) {
        super.init(frame: .zero)
        image = UIImage(systemName: imageTitle)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildViews() {
        createViews()
        addSubviews()
        configureViews()
    }

    private func createViews() {
        imageView = UIImageView(image: image)
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func configureViews() {
        styleViews()
        addConstraints()
    }

    private func styleViews() {
        layer.backgroundColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 0.6).cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
        tintColor = .white
    }

    private func addConstraints() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(14)
            $0.height.equalTo(13)
        }
    }
}

