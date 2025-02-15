import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.yourcompany.wifiReconnect",
            using: nil
        ) { task in
            self.handleWiFiReconnect(task: task as! BGProcessingTask)
        }

        return true
    }

    func handleWiFiReconnect(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        DispatchQueue.global(qos: .background).async {
            // Reconnect WiFi
            WiFiForIoTPlugin.connect(
                ssid: "Your_SSID",
                password: "Your_Password",
                security: .WPA,
                withInternet: true
            )
            
            task.setTaskCompleted(success: true)
        }
    }
}
