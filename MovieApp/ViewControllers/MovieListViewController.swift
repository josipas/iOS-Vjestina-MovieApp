import UIKit
import SnapKit
import MovieAppData

class MovieListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        print(Movies.all())
    }
}
