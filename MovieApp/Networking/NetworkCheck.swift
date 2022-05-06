import Network

class NetworkCheck {
    private var monitor = NWPathMonitor()
    private static let _sharedInstance = NetworkCheck()

    class func sharedInstance() -> NetworkCheck {
        return _sharedInstance
    }

    init() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }

    func getCurrentStatus() -> NWPath.Status {
        return monitor.currentPath.status
    }
}
