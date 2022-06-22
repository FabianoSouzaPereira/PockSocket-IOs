//
//  SocketPositionManagerDelegate.swift
//  PockSocket
//
//  Created by Fabiano Pereira on 22/06/22.
//

import UIKit

//Protocol implemented by the controller allowing SocketManager.
protocol SocketPositionManagerDelegate: AnyObject {
    func didConnect()
    func didReceive(position: CGPoint)
}
