//
//  PacketTunnelProvider.swift
//  OVPNExtension
//
//  Created by Hassan on 13/10/2024.
//
import Foundation
import TunnelKitOpenVPNAppExtension


class PacketTunnelProvider: OpenVPNTunnelProvider {
    override func startTunnel(options: [String : NSObject]? = nil) async throws {
        dnsTimeout = OpenVPNTunnel.dnsTimeout
        logSeparator = OpenVPNTunnel.sessionMarker
        dataCountInterval = OpenVPNTunnel.dataCountInterval
        try await super.startTunnel(options: options)
        
    }
}

enum OpenVPNTunnel {
        static let dnsTimeout = 5000

        static let sessionMarker = "--- EOF ---"

        static let dataCountInterval = 5000
    }

