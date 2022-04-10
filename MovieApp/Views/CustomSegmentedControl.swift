import UIKit

class CustomSegmentedControl: UIView {
    private var buttonTitles: [String]?

    private var stackView: UIStackView!

    init(buttonTitles: [String]) {
        super.init(frame: .zero)
        self.buttonTitles = buttonTitles

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
        stackView = UIStackView()
    }

    private func addSubviews() {
        addSubview(stackView)
        buttonTitles?.forEach({ title in
            let view = SegmentView(title: title)
            view.delegate = self
            stackView.addArrangedSubview(view)
        })
    }

    private func styleViews() {
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 22

        (stackView.arrangedSubviews[0] as! SegmentView).reloadData(state: true)
    }

    private func addConstraints() {
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension CustomSegmentedControl: SegmentDelegate {
    func segmentTapped(view: SegmentView) {
        let views = stackView.arrangedSubviews
        view.reloadData(state: true)

        views.forEach { currentView in
            if currentView != view {
                let segment = currentView as! SegmentView
                segment.reloadData(state: false)
            }
        }
    }
}
