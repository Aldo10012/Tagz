//
//  Sound.swift
//  Tagz
//
//  Created by Alberto Dominguez on 12/8/21.
//

import Foundation
import SpriteKit

enum Sound : String {
    case WalkingOnGrass
    
    var action: SKAction {
        return SKAction.playSoundFileNamed(rawValue + ".wav", waitForCompletion: true)
    }
}

