//
//  SocketManager.swift
//  AQI
//
//  Created by RajeshKumar G A on 05/02/22.
//

import Foundation

protocol AQDelegate: AnyObject {
    func didUpdateData(serverData: AirQuality)
}

final class SocketManager: WebSocketConnectionDelegate {
    static let shared = SocketManager()
    static weak var delegate:AQDelegate?
    private init(){}
    
    func onConnected(connection: WebSocketConnection) {
        print("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            print("Disconnected with error:\(error)")
        } else {
            print("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        print("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        if let airQualityData = try? AirQuality(text) {
            SocketManager.delegate?.didUpdateData(serverData: airQualityData)
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        print("Data message: \(data)")
    }
    
    var webSocketConnection: WebSocketConnection!
    
    func connect() {
        if let url  = URL(string: Constants.cityAQIurl) {
            webSocketConnection = WebSocketTaskConnection(url: url)
            webSocketConnection.delegate = self
            webSocketConnection.connect()
        } else {
            print(Constants.invalidURL)
        }
    }
}
