import UIKit

class CustomSegmentedControl: UIView {
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!

    init() {
        super.init(frame: .zero)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        addConstraints()
    }

    func addConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }

    func addArrangedSubview(_ view: UIView) {
        if stackView.arrangedSubviews.count == 0 {
            let view = view as? SegmentView
            view?.reloadData(state: true)
        }

        stackView.addArrangedSubview(view)
    }

    func reloadData(view: SegmentView) {
        let views = stackView.arrangedSubviews
        view.reloadData(state: true)

        views.forEach { currentView in
            if currentView != view {
                let segment = currentView as! SegmentView
                segment.reloadData(state: false)
            }
        }
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        stackView = UIStackView()
        scrollView = UIScrollView()
    }

    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }

    private func styleViews() {
        stackView.axis = .horizontal
        stackView.spacing = 22

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
}
