//

import Foundation
import AppKit



class LabelCollectionViewItem: NSCollectionViewItem {
	let keys = NSNotificationCenterKeys()
    let tookColor = StyleKit.on
    let currentColor = StyleKit.standbye
    let emptyColor = StyleKit.oval15Copy3
    let serialComm = SerialCommunicationController()
    
	// MARK: properties
	
	var slice:Slice? {
        return representedObject as? Slice
   }
	
	override var selected: Bool {
		didSet {
			(self.view as! LabelCollectionViewItemView).selected = selected
            
            if !selected{
                self.view.wantsLayer = true
                self.view.layer?.backgroundColor = slice!.itemColor.CGColor
            }

		}
        
	}
    
	override var highlightState: NSCollectionViewItemHighlightState {
		didSet {
			(self.view as! LabelCollectionViewItemView).highlightState = highlightState
            self.view.wantsLayer = true
            
		}
        
    }

	// MARK: outlets
	
	@IBOutlet weak var label: NSTextField!
    @IBOutlet weak var goToFrameBtn: NSMenuItem!
    @IBOutlet weak var takePictureBtn: NSMenuItem!
    @IBOutlet weak var resetFrameBtn: NSMenuItem!
    
    
    // CONTEXTUAL ACTIONS

    @IBAction func goToFrame(sender: AnyObject) {
       
//       slice!.goToFrame()
        
        slice!.goToFrameWithcallBack({() -> Void in
            
                print("completed action")
            
        })
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        
        //        slice!.position = getPosition(slice!.indexFrame,maxRows: collectionView.maxNumberOfRows,maxColumns: collectionView.maxNumberOfColumns)
//        slice!.status = .standbye
//        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
//        print ("GO TO POSITION\(slice!.stepPosition)")
//        
//        let xString = String(slice!.stepPosition.x)
//        let yString = String(slice!.stepPosition.y)
//        
//        let string = xString + "," + yString
//        let moveToInfo = ["moveTo" : string]
//        NSNotificationCenter.defaultCenter().postNotificationName(keys.moveTo, object: self, userInfo: moveToInfo)
        
        
        
            }
    
    
    @IBAction func takePicture(sender: AnyObject) {
        slice!.status = .took
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        
    }
    
    @IBAction func resetFrame(sender: AnyObject) {
        slice!.status = .empty
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        
    }
    // RUNTIME
    
    override func viewDidLoad() {
        
       
    }

	// MARK: NSResponder

	override func mouseDown(theEvent: NSEvent) {
		if theEvent.clickCount == 2 {
			print("Double click \(slice!.indexFrame)")
            slice!.status = .took
            self.view.layer?.backgroundColor = slice!.itemColor.CGColor
            print(slice!.status)
            
		} else {
			super.mouseDown(theEvent)
		}
		
	}
    
    
    // MARK: CUSTOM FUNCTIONS
    
    
}

