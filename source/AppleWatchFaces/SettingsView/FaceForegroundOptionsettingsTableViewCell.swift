//
//  EffectsWidthSettingsTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 4/5/19.
//  Copyright © 2019 Michael Hill. All rights reserved.
//


import UIKit

class FaceForegroundOptionSettingsTableViewCell : WatchSettingsSelectableTableViewCell {
    
    @IBOutlet var fieldTypeSegment:UISegmentedControl!
    @IBOutlet var shapeTypeSegment:UISegmentedControl!
    //@IBOutlet var shapeSizeSlider:UISlider!
    
    // called after a new setting should be selected ( IE a new design is loaded )
    override func chooseSetting( animated: Bool ) {
        guard let clockOverlaySettings = SettingsViewController.currentClockSetting.clockOverlaySettings else { return }
        
        if let segmentIndex = OverlayShapeTypes.userSelectableValues.index(of: clockOverlaySettings.shapeType) {
            shapeTypeSegment.selectedSegmentIndex = segmentIndex
        }
        
        if let typeSegmentIndex = PhysicsFieldTypes.userSelectableValues.index(of: clockOverlaySettings.fieldType) {
            fieldTypeSegment.selectedSegmentIndex = typeSegmentIndex
        }
       
    }
    
    @IBAction func typeSegmentValueDidChange ( sender: UISegmentedControl) {
        guard let clockOverlaySettings = SettingsViewController.currentClockSetting.clockOverlaySettings else { return }
        
        clockOverlaySettings.fieldType = PhysicsFieldTypes.userSelectableValues[sender.selectedSegmentIndex]
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                        userInfo:["cellId": self.cellId , "settingType":"faceForegroundOption"])
    }
    
    @IBAction func shapeSegmentValueDidChange ( sender: UISegmentedControl) {
        guard let clockOverlaySettings = SettingsViewController.currentClockSetting.clockOverlaySettings else { return }
        
        clockOverlaySettings.shapeType = OverlayShapeTypes.userSelectableValues[sender.selectedSegmentIndex]
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                            userInfo:["cellId": self.cellId , "settingType":"faceForegroundOption"])
    }
    
    @IBAction func minuteHandWidthSliderValueDidChange ( sender: UISlider) {
        guard let clockFaceSettings = SettingsViewController.currentClockSetting.clockFaceSettings else { return }
        
        //add to undo stack for actions to be able to undo
        SettingsViewController.addToUndoStack()
        
        let thresholdForChange:Float = 0.1
        let roundedValue = Float(round(50*sender.value)/50)
        var didChangeSetting = false
        
        //default it
        if clockFaceSettings.handEffectWidths.count < 3 {
            clockFaceSettings.handEffectWidths = [0,0,0]
        }
        
        if let currentVal = clockFaceSettings.handEffectWidths[safe: 1] {
            if abs(roundedValue.distance(to: currentVal)) > thresholdForChange || roundedValue == 0 {
                clockFaceSettings.handEffectWidths[1] = roundedValue
                didChangeSetting = true
            }
        } else {
            debugPrint("WARNING: no hand effect width array index to modify")
        }
        
        if didChangeSetting {
            NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
            NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
                                            userInfo:["cellId": self.cellId , "settingType":"handEffectWidths"])
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        
        //set up segment
        shapeTypeSegment.removeAllSegments()
        for (index, description) in ClockOverlaySetting.overlayShapeTypeDescriptions().enumerated() {
            shapeTypeSegment.insertSegment(withTitle: description, at: index, animated: false)
        }
        
        fieldTypeSegment.removeAllSegments()
        for (index, description) in FaceForegroundNode.physicFieldsTypeDescriptions().enumerated() {
            fieldTypeSegment.insertSegment(withTitle: description, at: index, animated: false)
        }
        
//        effectWidthSecondHandSlider.minimumValue = AppUISettings.handEffectSettigsSliderSpacerMin
//        effectWidthSecondHandSlider.maximumValue = AppUISettings.handEffectSettigsSliderSpacerMax
//
    }
    
}

