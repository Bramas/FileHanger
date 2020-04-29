//
//  StatusItem.swift
//  FileHanger
//
//  Created by bramas on 28/04/2020.
//  Copyright © 2020 bramas. All rights reserved.
//


import Cocoa

class StatusItemView: NSTextField {
    
    /* Other possible icons
    let textEmpty  = "📪"
    let textFull   = "📬"
    let textAccept = "📭"*/
    
    let textEmpty  = "◻"
    let textFull   = "◼"
    let textAccept = "▣"
    
    var clippedFiles = [NSURL]()
    var pasteboardItems : [NSPasteboardItem] = []
    var mouseClickAction: Selector!
    var mouseClickActionTarget: Any!
    
    let supportedTypes: [NSPasteboard.PasteboardType] = [.string, .fileURL]
    
    func setup(target:Any, action:Selector) {
        self.registerForDraggedTypes(supportedTypes)
        self.font = NSFont(name: "Arial", size: 22)
        self.stringValue = textEmpty
        
        self.isEditable = false
        self.isSelectable = false
        self.isBordered = false
        self.backgroundColor = nil
        print("loaded")
        mouseClickActionTarget = target
        mouseClickAction = action
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.stringValue = textAccept
        return .move
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {

        if let pi = sender.draggingPasteboard.pasteboardItems {
            pasteboardItems = pi
        }
        
        guard let pasteboardObjects =
            sender.draggingPasteboard.readObjects(
                forClasses: [NSString.self, NSURL.self]
            ),
            pasteboardObjects.count > 0
            else {
                return false
            }
        
        pasteboardObjects.forEach { (object) in
            if let url = object as? NSURL {
                self.clippedFiles.append(url)
            }
        }
        print(clippedFiles)
        self.stringValue = textFull
        return true
    }
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        
    }
    override func draggingEnded(_ sender: NSDraggingInfo) {
        
    }
    override func draggingExited(_ sender: NSDraggingInfo?) {
        
        if clippedFiles.count > 0 {
            self.stringValue = textFull
        } else {
            self.stringValue = textEmpty
        }
    }
    
    
    override func mouseDown(with event: NSEvent) {
        
        var dr_items = [NSDraggingItem]()
        
        for u in clippedFiles {

          let dr_item: NSDraggingItem
          dr_item = NSDraggingItem(pasteboardWriter: u)
          guard let p = u.path else {print("not a path"); continue}
            
          dr_item.setDraggingFrame(NSRect(x: 0, y: 0, width: 32, height: 32), contents: NSWorkspace.shared.icon(forFile: p))
          print(p)
          dr_items.append( dr_item )

        }
        
        if dr_items.count  == 0 {
            let t = Thread.init(target: mouseClickActionTarget, selector: mouseClickAction, object: nil)
            t.start()
            return
        }
        
        let session = self.beginDraggingSession(with: dr_items, event: event, source: self)
        session.draggingFormation = .pile
        clippedFiles = []
        self.stringValue = textEmpty
    }
    
}


// MARK: - NSDraggingSource
extension StatusItemView: NSDraggingSource {

    func draggingSession(_ ds: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        ds.draggingFormation = .pile
        return .move
    }
    
    //Returns whether the modifier keys will be ignored for this dragging session.
    func ignoreModifierKeys(for: NSDraggingSession) -> Bool {
        return false
    }
}


