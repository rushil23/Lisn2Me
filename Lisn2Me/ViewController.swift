//
//  ViewController.swift
//  Lisn2Me
//
//  Created by Rushil Nagarsheth on 31/05/19.
//  Copyright © 2019 Rushil Nagarsheth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Color Scheme
    let darkRed = UIColor(rgb: 0xb71c1c)
    let crimsonRed = UIColor(rgb: 0xd50000)
    let mediumRed = UIColor(rgb: 0xf44336)
    let lightRed = UIColor(rgb: 0xffcdd2)
    let selectedRed = UIColor(rgb: 0xef5350)
    
    let playService = PlayService()
    
    @IBOutlet weak var nowPlaying: UILabel!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    
    
    
    @IBAction func goLiveSwitchToggled(_ sender: UISwitch) {
        
        let isOn = sender.isOn == true
        
        if (isOn) {
            playService.goLive()
        } else {
            playService.goOffline()
        }
        
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        print("Play tapped")
        let text = UIDevice.current.name
        self.nowPlaying.text = text
        playService.send(songUri: text)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playService.delegate = self
    }
    
    func refreshData(_ connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.deviceName.text = "\(connectedDevices)"
            self.connectionsLabel.text = "Connections: \(self.playService.session.connectedPeers.count) Device(s) Connected!"
        }
    }
    
    


}

extension ViewController : PlayServiceDelegate {
    
    func connectedDevicesChanged(manager: PlayService, connectedDevices: [String]) {
        refreshData(connectedDevices)
    }
    
    func playTapReceived(manager: PlayService, songUri: String) {
        OperationQueue.main.addOperation {
            self.nowPlaying.text = songUri
            print("Received song name = \(songUri)")
            
        }
    }
    
}


//MARK: Helper functions to get UIColor directly using Hex code
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
