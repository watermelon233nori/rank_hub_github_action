//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by 千沫qianmo on 2024/12/13.
//

import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let settings =  NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        settings.ipv4Settings = NEIPv4Settings(addresses: ["192.168.0.1"], subnetMasks: ["255.255.255.0"])
        settings.ipv4Settings?.includedRoutes = [NEIPv4Route.default()]
        
        setTunnelNetworkSettings(settings) {error in
            if let error = error {
                completionHandler(error)
            } else {
                self.startCapturtingPackets()
                completionHandler(nil)
            }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    private func startCapturtingPackets() {
        self.packetFlow.readPackets { packets, protocols in
            for packet in packets {
                print("Captured packet: \(packet)")
            }
            self.startCapturtingPackets()
        }
    }
}
