//
//  AppDelegate.swift
//  MonkeySeeMonkeyDo
//
//  Created by Arun Sasidharan on 22/03/20.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        toggleIcon()
        statusItem.button?.action = #selector(statusBarIconClicked)
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc func statusBarIconClicked() {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            NSApp.terminate(nil)
        } else {
            toggleDesktopIcons()
        }
    }
    
    private func toggleDesktopIcons() {
        // Write Defaults
        let createDesktop = "CreateDesktop"
        let finderDefault = UserDefaults(suiteName: "com.apple.finder")
        
        if finderDefault?.bool(forKey: createDesktop) == true {
            finderDefault?.set(false, forKey: createDesktop)
        } else {
            finderDefault?.set(true, forKey: createDesktop)
        }
        
        // restart Finder
        let killTask = Process()
        killTask.launchPath = "/usr/bin/killall"
        killTask.arguments = ["Finder"]
        
        killTask.launch()
        killTask.waitUntilExit()
        
        toggleIcon()
    }
    
    private func toggleIcon() {
        let createDesktop = "CreateDesktop"
        let finderDefault = UserDefaults(suiteName: "com.apple.finder")
        let icon: String
        
        if finderDefault?.bool(forKey: createDesktop) == true {
            icon = "monkey-open"
        } else {
            icon = "monkey-closed"
        }
        
        statusItem.button?.image = NSImage(named:NSImage.Name(icon))
        statusItem.button?.image?.size = NSSize(width: 19, height: 18)
    }
    
}

