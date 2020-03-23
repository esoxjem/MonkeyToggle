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
        writeToDefaults()
        restartFinder()
        toggleIcon()
    }
    
    private func writeToDefaults() {
        let createDesktop = "CreateDesktop"
        let finderDefault = UserDefaults(suiteName: "com.apple.finder")
        
        if finderDefault?.bool(forKey: createDesktop) == true {
            finderDefault?.set(false, forKey: createDesktop)
        } else {
            finderDefault?.set(true, forKey: createDesktop)
        }
    }
    
    private func restartFinder() {
        let killTask = Process()
        killTask.launchPath = "/usr/bin/killall"
        killTask.arguments = ["Finder"]
        
        killTask.launch()
        killTask.waitUntilExit()
    }
    
    private func toggleIcon() {
        let createDesktop = "CreateDesktop"
        let finderDefault = UserDefaults(suiteName: "com.apple.finder")
        let icon: String
        
        if finderDefault?.bool(forKey: createDesktop) == true {
            icon = "visible"
        } else {
            icon = "hidden"
        }
        
        statusItem.button?.image = NSImage(named:NSImage.Name(icon))
    }
    
}

