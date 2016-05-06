//

import Foundation
import AppKit

class LabelCollectionViewItemView: NSView {

    
	// MARK: VARIABLES
    
	var selected: Bool = false {
		didSet {
			if selected != oldValue {
				needsDisplay = true
			}
        
		}
	}
    
	var highlightState: NSCollectionViewItemHighlightState = .None {
		
        didSet {
			if highlightState != oldValue {
                
				needsDisplay = true
			}
		}
	}
	
    
    // MARK: IBOUTLETS
    
    @IBOutlet weak var cellContextMenu: NSMenu!
    @IBOutlet weak var goToFrameBtn: NSMenuItem!
    @IBOutlet weak var takePictureBtn: NSMenuItem!
    @IBOutlet weak var resetFrameBtn: NSMenuItem!
	
    
    // MARK: Update View Methods
	
    
    override var wantsUpdateLayer: Bool {
		return true
	}

	override func updateLayer() {
		if selected {
			self.layer?.cornerRadius = 0
            self.layer?.borderColor = NSColor.whiteColor().CGColor
            self.layer?.borderWidth = 1.0
           
		} else {
			self.layer?.cornerRadius = 0
            self.layer?.borderColor = StyleKit.separator.CGColor
            self.layer?.borderWidth = 0.5
           		}
	}
    
    

	// MARK: init
    
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		wantsLayer = true
		layer?.masksToBounds = true
        
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		wantsLayer = true
		layer?.masksToBounds = true
	}
}