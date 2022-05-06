import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
    }

    func createTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()

        setUpTabBar(tabBarController: tabBarController)

        tabBarController.viewControllers = [createMovieListNavigationController(), createFavoritesNavigationController()]

        return tabBarController
    }

    func createMovieListNavigationController() -> UINavigationController {
        let movieListViewController = MovieListViewController()

        movieListViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))

        return UINavigationController(rootViewController: movieListViewController)
    }

    func createFavoritesNavigationController() -> UINavigationController {
        let favoritesViewController = FavoritesViewController()

        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

        return UINavigationController(rootViewController: favoritesViewController)
    }

    func setUpTabBar(tabBarController: UITabBarController) {
        UITabBar.appearance().backgroundColor = .white
        tabBarController.tabBar.tintColor = UIColor(hex: "#0B253F")
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController.tabBar.layer.shadowRadius = 4.0
        tabBarController.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.3
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

