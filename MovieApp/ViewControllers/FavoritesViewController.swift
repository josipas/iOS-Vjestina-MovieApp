import UIKit

class FavoritesViewController: UIViewController {
    private var navigationBarImageView: UIImageView!
    private var navigationBarImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationBarImageView = UIImageView()
        navigationBarImage = UIImage(named: "tmdb")

        navigationBarImageView.frame = CGRect(x: 0, y: 0, width: 145, height: 35)
        navigationBarImageView.image = navigationBarImage

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: "#0B253F")
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationItem.titleView = navigationBarImageView
    }
}
