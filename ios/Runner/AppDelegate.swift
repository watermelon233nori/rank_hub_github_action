import Flutter
import UIKit
import NetworkExtension

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "fun.meow0.rankhub.network", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startTunnel":
                self?.startTunnel(result: result)
            case "stopTunnel":
                self?.stopTunnel(result: result)
            default:
                result(FlutterMethodNotImplemented)
                
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func startTunnel(result: @escaping FlutterResult) {
        let manager = NETunnelProviderManager()
        
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                print("Error loading tunnel configurations: \(error)")
                result(FlutterError(code: "LOAD_ERROR", message: "Failed to load tunnel configurations", details: error.localizedDescription))
                return
            }
            
            if let existingManager = managers?.first {
                self.configureAndStart(manager: existingManager, result: result)
            } else {
                self.configureAndStart(manager: manager, result: result)
            }
        }
    }
    
    private func configureAndStart(manager: NETunnelProviderManager, result: @escaping FlutterResult) {
        manager.localizedDescription = "Packet Tunnel"
        manager.protocolConfiguration = NETunnelProviderProtocol()
        manager.protocolConfiguration?.serverAddress = "127.0.0.1"
        manager.isEnabled = true
        
        manager.saveToPreferences { error in
            if let error = error {
                print("Error saving preferences: \(error)")
                result(FlutterError(code: "SAVE_ERROR", message: "Failed to save preferences", details: error.localizedDescription))
                return
            }
            
            manager.loadFromPreferences { error in
                if let error = error {
                    print("Error loading preferences: \(error)")
                    result(FlutterError(code: "LOAD_ERROR", message: "Failed to load preferences", details: error.localizedDescription))
                    return
                }
                
                do {
                    try manager.connection.startVPNTunnel()
                    print("Tunnel started")
                    result(nil)
                } catch let startError {
                    print("Failed to start tunnel: \(startError)")
                    result(FlutterError(code: "START_ERROR", message: "Failed to start tunnel", details: startError.localizedDescription))
                }
            }
        }
    }
    
    private func stopTunnel(result: @escaping FlutterResult) {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                print("Error loading tunnel configurations: \(error)")
                result(FlutterError(code: "LOAD_ERROR", message: "Failed to load tunnel configurations", details: error.localizedDescription))
                return
            }
            
            if let manager = managers?.first {
                manager.connection.stopVPNTunnel()
                print("Tunnel stopped")
                result(nil)
            } else {
                result(FlutterError(code: "STOP_ERROR", message: "No active tunnel found", details: nil))
            }
        }
    }
}
