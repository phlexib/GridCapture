//

import Foundation
import AppKit



class LabelCollectionViewItem: NSCollectionViewItem {
	
    let tookColor = StyleKit.on
    let currentColor = StyleKit.standbye
    let emptyColor = StyleKit.oval15Copy3
    
    
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
//            slice!.status = .current
//            self.view.layer?.backgroundColor = slice!.itemColor.CGColor
            
		}
        
    }

	// MARK: outlets
	
	@IBOutlet weak var label: NSTextField!
    @IBOutlet weak var goToFrameBtn: NSMenuItem!
    @IBOutlet weak var takePictureBtn: NSMenuItem!
    @IBOutlet weak var resetFrameBtn: NSMenuItem!
    
    
    // CONTEXTUAL ACTIONS

    @IBAction func goToFrame(sender: AnyObject) {
        slice!.position = getPosition(slice!.indexFrame,maxRows: collectionView.maxNumberOfRows,maxColumns: collectionView.maxNumberOfColumns)
        slice!.status = .current
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        print ("GO TO POSITION\(slice!.stepPosition)")
            }
    @IBAction func takePicture(sender: AnyObject) {
        slice!.status = .took
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        
    }
    
    @IBAction func resetFrame(sender: AnyObject) {
        slice!.status = .empty
        self.view.layer?.backgroundColor = slice!.itemColor.CGColor
        
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
    
    func getPosition(itemIndex : Int , maxRows: Int, maxColumns : Int)-> (x: Int, y: Int){
        // Get X and Y Index from CollectionView
        
        var sliceColumn = itemIndex % maxColumns
        
        if sliceColumn == 0{
            sliceColumn = maxColumns
        }
        
        
        let sliceRowFloat =   Float(slice!.indexFrame) / Float(maxColumns)
        let sliceRow = Int(ceil(sliceRowFloat))

        return (sliceColumn,sliceRow)

    }
}

