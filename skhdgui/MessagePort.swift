//
//  MessagePort.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/2/22.
//

import Foundation

protocol MessagePortDelegate {
    func receive(_ request: Request)
}

class MessagePortServer {
    static let shared = MessagePortServer()
    let port : CFMessagePort
    public var delegate : MessagePortDelegate?
    
    private init() {
        var ctx = CFMessagePortContext()
        
        guard let port = CFMessagePortCreateLocal(kCFAllocatorDefault, "skhdgui.skhdgui.messageport" as CFString, { port, i, data, _ -> Unmanaged<CFData>? in
            guard let data = data as? Data else {
                print("Invalid data received on message port.")
                return nil
            }
            
            do {
                let requests = try JSONDecoder().decode([Request].self, from: data)
                for request in requests {
                    MessagePortServer.shared.delegate?.receive(request)
                }
            } catch {
                print(error)
            }
            
            return nil
        }, &ctx, .init(bitPattern: 0)) else {
            print("Error: Gui already running!")
            exit(1)
        }
        
        self.port = port

        CFRunLoopAddSource(CFRunLoopGetCurrent(), CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, port, 0), .defaultMode)
    }
}

class MessagePortClient {
    static let shared = MessagePortClient()
    let port : CFMessagePort
    
    init() {
        guard let port = CFMessagePortCreateRemote(kCFAllocatorDefault, "skhdgui.skhdgui.messageport" as CFString) else {
            print("Error opening message port to GUI. Is the gui running?")
            exit(1)
        }
        self.port = port
    }
    
    func send(_ requests: [Request]) {
        do {
            let data = try JSONEncoder().encode(requests)

            var res : Unmanaged<CFData>?
            CFMessagePortSendRequest(port, 0, data as CFData, .infinity, .infinity, CFRunLoopMode.defaultMode.rawValue, &res)
        } catch {
            print(error)
        }
    }
}
