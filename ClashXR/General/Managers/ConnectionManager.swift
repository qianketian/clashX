//
//  ConnectionManager.swift
//  ClashX
//
//  Created by yichengchen on 2019/10/28.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa

class ConnectionManager {
    static var enableAutoClose = UserDefaults.standard.object(forKey: "ConnectionManager.enableAutoClose") as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(enableAutoClose, forKey: "ConnectionManager.enableAutoClose")
        }
    }

    static func addCloseOptionMenuItem(_ menu: inout NSMenu) {
        let item = NSMenuItem(title: NSLocalizedString("Auto Close Connection", comment: ""), action: #selector(optionMenuItemTap(sender:)), keyEquivalent: "")
        item.target = ConnectionManager.self
        menu.addItem(item)
        updateMenuItemStatus(item)
    }

    static func closeConnection(for group: String) {
        guard enableAutoClose else { return }
        ApiRequest.getConnections { conns in
            for conn in conns {
                if conn.chains.contains(group) {
                    ApiRequest.closeConnection(conn)
                }
            }
        }
    }

    static func closeConnectionExpectDirect() {
        guard enableAutoClose else { return }
        ApiRequest.getConnections { conns in
            for conn in conns {
                if !conn.chains.contains("DIRECT") {
                    ApiRequest.closeConnection(conn)
                }
            }
        }
    }

    static func closeAllConnection() {
        ApiRequest.getConnections { conns in
            for conn in conns {
                ApiRequest.closeConnection(conn)
            }
        }
    }
}

private extension ConnectionManager {
    static func updateMenuItemStatus(_ item: NSMenuItem) {
        item.state = enableAutoClose ? .on : .off
    }

    @objc static func optionMenuItemTap(sender: NSMenuItem) {
        enableAutoClose = !enableAutoClose
        updateMenuItemStatus(sender)
    }
}
