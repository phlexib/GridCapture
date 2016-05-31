//
//  SerialCommunication.swift
//  GridCapture
//
//  Created by ben on 01/05/2016.
//  Copyright © 2016 Benjamin Rohel. All rights reserved.
//

import Cocoa
import ORSSerial

class SerialCommunicationController: NSViewController, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {
    
    
    // MARK: - VARIABLES
    
    enum dataTosend : String{
        
        case right = "!r"
        case left = "!l"
        case up = "!u"
        case down = "!d"
        case goTo = "!g"
        case setStart = "!a"
        case setEnd = "!b"
        case startMove = "!m"
        case stop = "!s"
        case home = "!h"
        case zero = "!z"
        
        func simpleDescription() -> String {
            
            switch self {
            case .right:
                return "!r"
            case .left:
                return "!l"
            case .up:
                return "!u"
            case .down:
                return "!d"
            case .goTo:
                return "!g"
            case .setStart:
                return "!a"
            case .setEnd:
                return "!b"
            case .startMove:
                return "!m"
            case .stop:
                return "!s"
            case .home:
                return "!h"
            case .zero:
                return "1z"
            }
        }
        
    }

    
    let keys = NSNotificationCenterKeys() // Keys for Notifications
    var currentIncomingString = NSString()
    var stringReceived = NSString()
   
    
    // OrsSerial Variables
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    var shouldAddLineEnding = false
    
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }

    
    //  MARK: - IBOUTLETS
    
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet weak var rigStatusIndicator : StatusBtn!
    @IBOutlet weak var zeroBtn: NSButton!
    @IBOutlet weak var rightBtn: NSButton!
    
    
    
    // MARK: - ACTIONS
    
    // Send data from Buttons
    @IBAction func send(sender : AnyObject) {
        
        sender.sendActionOn(Int(NSEventMask.LeftMouseDownMask.rawValue))

        var string = "test"
        let btnId = (sender as! NSButton).identifier!
        switch btnId{
            case "up" :
                string = dataTosend.up.rawValue
            case "down":
                string = dataTosend.down.rawValue
            case "left":
                string = dataTosend.left.rawValue
            case "right":
                string = dataTosend.right.rawValue
            case "stop":
                string = dataTosend.stop.rawValue
            case "home" :
                string = dataTosend.home.rawValue
            case "zero" :
            string = dataTosend.zero.rawValue
            let prefs = NSUserDefaults.standardUserDefaults()
            let storedX = 0
            let storedY = 0
            //                   let storedPosition [String:]= ["pos":position]
            prefs.setValue(storedX, forKey: "xPosition")
            prefs.setValue(storedY, forKey: "yPosition")
        default :
                string = "s"
            
        }
        let stringtoSend = string + "\n"
                if let data = stringtoSend.dataUsingEncoding(NSUTF8StringEncoding) {
            print("sent \(stringtoSend)")
            self.serialPort?.sendData(data)
        }
    }
    

    
    // Set StartPoint of Grid
    @IBAction func setStart(sender: AnyObject) {
        
         NSNotificationCenter.defaultCenter().postNotificationName(keys.start, object: self)
        let string = dataTosend.setStart.rawValue
        let stringtoSend = string + "\n"
        if let data = stringtoSend.dataUsingEncoding(NSUTF8StringEncoding) {
            print("sent \(stringtoSend)")
            self.serialPort?.sendData(data)
        }
    }
    
    
    // Set EndPoint Of Grid
    @IBAction func setEnd(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(keys.start, object: self)
        let string = dataTosend.setEnd.rawValue
        let stringtoSend = string + "\n"
        if let data = stringtoSend.dataUsingEncoding(NSUTF8StringEncoding) {
            print("sent \(stringtoSend)")
            self.serialPort?.sendData(data)
        }
    }
    
    
    // Manage OpenClose Port Interface
    @IBAction func openOrClosePort(sender: AnyObject) {
        
        if let port = self.serialPort {
            if (port.open) {
                port.close()
                self.rigStatusIndicator.statusBtnColor = StyleKit.off
                self.rigStatusIndicator.needsDisplay = true

            } else {
                port.open()
                
                self.rigStatusIndicator.statusBtnColor = StyleKit.on
                self.rigStatusIndicator.needsDisplay = true
            }
        }
    }
    
    
    
    // MARK: - RUNTIME
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SerialCommunicationController.moveToPosition), name: keys.moveTo, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SerialCommunicationController.updateCameraPosition), name: keys.cameraPositionKey, object: nil)
        
        rightBtn.setPeriodicDelay(1, interval: 1)
        
        
    }
    
       
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        let descriptor = ORSSerialPacketDescriptor(prefixString: "!", suffixString: ";", maximumPacketLength: 50, userInfo: nil)
        serialPort.startListeningForPacketsMatchingDescriptor(descriptor)

        self.openCloseButton.title = "Close"
        serialPort.baudRate = 115200
            }
    
    
    func serialPortWasClosed(serialPort: ORSSerialPort) {
        self.openCloseButton.title = "Open"
    }
    
    
    func serialPort(serialPort: ORSSerialPort, didReceivePacket packetData: NSData, matchingDescriptor descriptor: ORSSerialPacketDescriptor) {
        if let dataAsString = NSString(data: packetData, encoding: NSASCIIStringEncoding) {
            
            var cleanString = String(String(dataAsString).characters.dropFirst())
            
                print("data received : \(cleanString)")
            
            if cleanString != currentIncomingString {
                if cleanString[0] == "g" {
                    cleanString = String(String(cleanString).characters.dropFirst())
                    cleanString = String(String(cleanString).characters.dropLast())
                    print(cleanString)
                    let position = keys.parseDataPosition(cleanString)
                    let posNotification = ["xPosition" : position.0, "yPosition" : position.1]
                    NSNotificationCenter.defaultCenter().postNotificationName(keys.cameraPositionKey, object: self, userInfo :posNotification)
                    currentIncomingString = cleanString
                }
                else if cleanString[0] == "#" {
                    cleanString = String(String(cleanString).characters.dropFirst())
                    cleanString = String(String(cleanString).characters.dropLast())
                    let posNotification = ["callback" : cleanString]
                    NSNotificationCenter.defaultCenter().postNotificationName(keys.arduinoCallback, object: self, userInfo :posNotification)
                    currentIncomingString = cleanString 
                                    }
                else if cleanString[0] == "p" {
                    cleanString = String(String(cleanString).characters.dropFirst())
                    cleanString = String(String(cleanString).characters.dropLast())
                    let prefs = NSUserDefaults.standardUserDefaults()
                    let position = keys.parseDataPosition(cleanString)
                    let storedX = position.x
                    let storedY = position.y
//                   let storedPosition [String:]= ["pos":position]
                    prefs.setValue(storedX, forKey: "xPosition")
                    prefs.setValue(storedY, forKey: "yPosition")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(keys.arrivedAtTarget, object: self)
                    currentIncomingString = cleanString

                }
                else if cleanString[0] == "c" {
                    cleanString = String(String(cleanString).characters.dropFirst())
                    cleanString = String(String(cleanString).characters.dropLast())
                    NSNotificationCenter.defaultCenter().postNotificationName(keys.pictureDone, object: self)
                    currentIncomingString = cleanString
                    
                }

                else{
                    print("Non Usable data from Arduino")
                }
            }
            
        }
    }
     
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    
    
    // MARK : NSNotificationCenter
    
    
    func updateCameraPosition(){

    }
    
    
    //  Func for New Movement
    func moveToPosition(notification : NSNotification){
        
        guard let userInfo = notification.userInfo,
            let targetString  = userInfo["moveTo"] as? String
            else {
                print("No userInfo found in notification")
                return
        }
        
        
        let toArray = targetString.componentsSeparatedByString(" ") // split String into Arra to remove Whitespace
        var cleanString = toArray.joinWithSeparator("")
        
        print("target set to : \(cleanString)")
        cleanString = dataTosend.goTo.rawValue + cleanString
        cleanString += "\n"
        if let data = cleanString.dataUsingEncoding(NSUTF8StringEncoding) {
            self.serialPort?.sendData(data)
        }
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

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
