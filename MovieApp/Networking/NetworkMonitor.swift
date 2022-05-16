import Network

class NetworkMonitor {
    let monitor = NWPathMonitor()

    func startMonitoring(connected: @escaping () -> Void, unconnected: @escaping () -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                connected()
            } else {
                unconnected()
            }
        }
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
