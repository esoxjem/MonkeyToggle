//
//  AppDelegate.swift
//  MonkeyToggle
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
        statusItem.button?.action = #selector(statusBarIconClicked(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc func statusBarIconClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        switch event.type {
        case .rightMouseUp: showMenu(sender)
        case .leftMouseUp: toggleDesktopIcons()
        default:
            break
        }
    }
    
    private func showMenu(_ sender: NSStatusBarButton) {
        let menu = NSMenu()
        let twitter = NSMenuItem(title: "@voidmaindev", action: #selector(twitter(_:)), keyEquivalent: "")
        let github = NSMenuItem(title: "GitHub", action: #selector(github(_:)), keyEquivalent: "")
        let quit = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        
        twitter.target = self
        github.target = self
        
        menu.addItem(twitter)
        menu.addItem(github)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quit)
        
        if let event = NSApplication.shared.currentEvent {
            NSMenu.popUpContextMenu(menu, with: event, for: sender)
        }
    }
    
    
    @objc private func twitter(_ sender: NSMenuItem) {
        let url = URL(string: "https://www.twitter.com/voidmaindev")!
        NSWorkspace.shared.open(url)
    }
    
    @objc private func github(_ sender: NSMenuItem) {
        let url = URL(string: "https://www.github.com/esoxjem/MonkeyToggle")!
        NSWorkspace.shared.open(url)
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

