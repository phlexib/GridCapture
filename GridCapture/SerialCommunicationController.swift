//
//  SerialCommunication.swift
//  GridCapture
//
//  Created by ben on 01/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa
import ORSSerial

class SerialCommunicationController: NSObject, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {
    
    enum dataString : String{
        case Down = "d"
        case Up = "u"
        case Left = "l"
        case Right = "r"
        case Stop = "s"
    }
    
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    var shouldAddLineEnding = false
    var xPosString : String = String()
    
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }

    var lineEndingString: String {
        let map = [0: "\r", 1: "\n", 2: "\r\n"]
//        if let result = map[self.lineEndingPopUpButton.selectedTag()] {
//            return "\n"
//        } else {
//            return "\n"
//        }
        return "\n"
    }
    @IBOutlet weak var xPosLabel: NSTextField!
    @IBOutlet weak var openCloseButton: NSButton!
    
    
    // MARK: - Actions
    
    @IBAction func send(sender : AnyObject) {
        var string = "test"
        let btnId = (sender as! NSButton).identifier!
        switch btnId{
            case "up" :
                string = "u"
            case "down":
                string = "d"
            case "left":
                string = "l"
            case "right":
                string = "r"
            case "stop":
                string = "s"
        default :
                string = "s"
            
        }
        
        string += "\n"
        
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            self.serialPort?.sendData(data)
        }
    }
    
    @IBAction func setStart(sender: AnyObject) {
        let string = "x"
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            self.serialPort?.sendData(data)
        }
    }
    
    
    @IBAction func setEnd(sender: AnyObject) {
        let string = "y"
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            self.serialPort?.sendData(data)
        }
    }
    
    
    @IBAction func openOrClosePort(sender: AnyObject) {
        if let port = self.serialPort {
            if (port.open) {
                port.close()
            } else {
                port.open()
//                self.receivedDataTextView.textStorage?.mutableString.setString("");
            }
        }
    }

    
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        self.openCloseButton.title = "Close"
        serialPort.baudRate = 115200
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort) {
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
//            self.receivedDataTextView.textStorage?.mutableString.appendString(string as String)
//            self.receivedDataTextView.needsDisplay = true
            xPosString = string as String
            var currentlabelString = xPosLabel.stringValue
            
            if xPosString != currentlabelString{
                xPosLabel.stringValue = string as String
                currentlabelString = xPosString as String
            }
          
            print(string)
            
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    

    
    // MARK: - NSUserNotifcationCenterDelegate
    
    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            center.removeDeliveredNotification(notification)
        }
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    // MARK: - Notifications
    
    func serialPortsWereConnected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let connectedPorts = userInfo[ORSConnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were connected: \(connectedPorts)")
            self.postUserNotificationForConnectedPorts(connectedPorts)
        }
    }
    
    func serialPortsWereDisconnected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let disconnectedPorts: [ORSSerialPort] = userInfo[ORSDisconnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were disconnected: \(disconnectedPorts)")
            self.postUserNotificationForDisconnectedPorts(disconnectedPorts)
        }
    }
    
    func postUserNotificationForConnectedPorts(connectedPorts: [ORSSerialPort]) {
        let unc = NSUserNotificationCenter.defaultUserNotificationCenter()
        for port in connectedPorts {
            let userNote = NSUserNotification()
            userNote.title = NSLocalizedString("Serial Port Connected", comment: "Serial Port Connected")
            userNote.informativeText = "Serial Port \(port.name) was connected to your Mac."
            userNote.soundName = nil;
            unc.deliverNotification(userNote)
        }
    }
    
    func postUserNotificationForDisconnectedPorts(disconnectedPorts: [ORSSerialPort]) {
        let unc = NSUserNotificationCenter.defaultUserNotificationCenter()
        for port in disconnectedPorts {
            let userNote = NSUserNotification()
            userNote.title = NSLocalizedString("Serial Port Disconnected", comment: "Serial Port Disconnected")
            userNote.informativeText = "Serial Port \(port.name) was disconnected from your Mac."
            userNote.soundName = nil;
            unc.deliverNotification(userNote)
        }
    }
}
