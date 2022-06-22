//
//  SocketTutorialManager.swift
//  PockSocket
//
//  Created by Fabiano Pereira on 22/06/22.
//

import UIKit
import SocketIO


class SocketTutorialManager {

    // MARK: - Delegate
    weak var delegate: SocketPositionManagerDelegate?

    // MARK: - Properties
    let manager = SocketManager(socketURL: URL(string: "https://socket-io-whiteboard.now.sh")!, config: [.log(false), .compress])
    var socket: SocketIOClient? = nil

    // MARK: - Life Cycle
    init(_ delegate: SocketPositionManagerDelegate) {
        self.delegate = delegate
        setupSocket()
        setupSocketEvents()
        socket?.connect()
    }

    func stop() {
        socket?.removeAllHandlers()
    }

    // MARK: - Socket Setups
    func setupSocket() {
        self.socket = manager.defaultSocket
    }

    
    func setupSocketEvents() {

        socket?.on(clientEvent: .connect) {data, ack in
            self.delegate?.didConnect()
        }

        socket?.on("drawing") { (data, ack) in
            guard let dataInfo = data.first else { return }
            if let response: CGPoint = try? SocketParser.convert(data: dataInfo) {
                let position = CGPoint.init(x: response.x, y: response.y)
                self.delegate?.didReceive(position: position)
            }
        }

    }

    // MARK: - Socket Emits
    func socketChanged(position: CGPoint) {
        let info: [String : Any] = [
            "x": Double(position.x),
            "y": Double(position.y)
        ]
        socket?.emit("drawing", info)
    }

}

struct CGPoint: Codable {
    var x: Double
    var y: Double
}
