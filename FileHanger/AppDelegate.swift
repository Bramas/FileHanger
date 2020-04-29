//
//  AppDelegate.swift
//  FileHanger
//
//  Created by bramas on 29/04/2020.
//  Copyright © 2020 bramas. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    var popover: NSPopover!
    var statusItem: NSStatusItem!
    var statusItemView: StatusItemView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController")
            as? ViewController else {
                fatalError("Unable to load ViewController from the storyboard")
        }
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 150, height: 60)
        popover.behavior = .transient
        popover.contentViewController = vc //NSHostingController(rootView: contentView)
        self.popover = popover
 
        // Create the status item
        self.statusItem = NSStatusBar.system.statusItem(withLength: 23)
        //(withLength: NSStatusItem.variableLength)

        self.statusItemView = StatusItemView(string: "---")
        self.statusItemView.setup(target: self, action: #selector(moveToMainThread))
        self.statusItem.button?.addSubview(self.statusItemView)
        
        
    }

    @objc func moveToMainThread()
    {
        print("moveToMainThread")
        performSelector(onMainThread: #selector(togglePopover(_:)), with: nil, waitUntilDone: false)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {

        print("togglePopover")
        if self.statusItemView.clippedFiles.count > 0 { return }
        
        if let button = self.statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    

}
