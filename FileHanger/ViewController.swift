//
//  ViewController.swift
//  FileHanger
//
//  Created by bramas on 29/04/2020.
//  Copyright © 2020 bramas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onQuit(_ sender: Any) {
        exit(EXIT_SUCCESS)
    }
    
}

