//
//  BankingHelperApp.swift
//  MenuBarApp
//
//  Created by Matheus Gois on 13/06/24.
//

import SwiftUI

@main
struct ClockMenuBarApp: App {
    @StateObject private var clockManager = ClockManager()
    
    var body: some Scene {
        MenuBarExtra(content: {
            ClockView(clockManager: clockManager)
        }, label: {
            Text("LA: \(clockManager.formattedTime(for: "America/Los_Angeles")) | NY: \(clockManager.formattedTime(for: "America/New_York"))")
                .monospaced()
        })
        .menuBarExtraStyle(.window)
    }
}

class ClockManager: ObservableObject {
    @Published var currentTime = Date()
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.currentTime = Date()
            }
        }
    }
    
    func formattedTime(for timeZone: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter.string(from: currentTime)
    }
}

struct ClockView: View {
    @ObservedObject var clockManager: ClockManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Current Time")
                .font(.headline)
            
            TimeRow(city: "Cupertino", timeZone: "America/Los_Angeles", currentTime: clockManager.currentTime)
            TimeRow(city: "New York", timeZone: "America/New_York", currentTime: clockManager.currentTime)
            
            Button("Exit") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(width: 200)
    }
}

struct TimeRow: View {
    let city: String
    let timeZone: String
    let currentTime: Date
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter.string(from: currentTime)
    }
    
    var body: some View {
        HStack {
            Text(city)
                .fontWeight(.bold)
            Spacer()
            Text(formattedTime)
                .monospaced()
        }
    }
}
