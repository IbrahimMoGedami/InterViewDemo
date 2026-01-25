//
//  HapticToolbox.swift
//  InterViewDemo
//
//  Haptic feedback toolbox using AudioToolbox
//

import Foundation
import AudioToolbox

actor HapticToolbox {
    
    static let shared: HapticToolbox = .init()
    
    func playStrongImpact() {
        AudioServicesPlaySystemSound(1519)
    }
    
    func playVeryStrongImpact() {
        AudioServicesPlaySystemSound(1520)
    }
    
    func playVibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playNotification() {
        AudioServicesPlaySystemSound(1521)
    }
}
