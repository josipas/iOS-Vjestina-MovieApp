import UIKit

protocol SegmentDelegate: AnyObject {
    func segmentTapped(view: SegmentView)
}

class SegmentView: UIView {
    private var title: String?
    private var label: UILabel!
    private var selectView: UIView!
    private var state = false

    weak var delegate: SegmentDelegate?

    init(title: String) {
        super.init(frame: .zero)
        self.title = title

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData(state: Bool) {
        switch state {
        case true:
            label.textColor = UIColor(hex: "#000000")
            label.font = .systemFont(ofSize: 16, weight: .bold)
            selectView.isHidden = false
        case false:
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor(hex: "#828282")
            selectView.isHidden = true
        }
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
        addGesture()
    }

    private func createViews() {
        label = UILabel()
        selectView = UIView()
    }

    private func addSubviews() {
        addSubview(label)
        addSubview(selectView)
    }

    private func styleViews() {
        label.text = title
        selectView.backgroundColor = UIColor(hex: "#0B253F")

        switch state {
        case true:
            label.textColor = UIColor(hex: "#000000")
            label.font = .systemFont(ofSize: 16, weight: .bold)
            selectView.isHidden = false
        case false:
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor(hex: "#828282")
            selectView.isHidden = true
        }
    }

    private func addConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        selectView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
            $0.top.equalTo(label.snp.bottom).offset(4)
        }
    }

    private func addGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(recognizer)
    }

    @objc private func viewTapped() {
        delegate?.segmentTapped(view: self)
    }
}
