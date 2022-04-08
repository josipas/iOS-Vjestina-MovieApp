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
        styleViews()
        addConstraints()
    }

    private func createViews() {
        imageView = UIImageView(image: image)
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func styleViews() {
        layer.backgroundColor = UIColor(hex: "#757575")?.cgColor
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

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.bounds.height / 2
    }
}

