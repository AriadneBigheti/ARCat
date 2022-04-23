//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 22/04/22.
//

import Foundation
import RealityKit

class AnimationComponent: Component{
    var modelEntity: Entity
    
    init(entity:Entity){
        modelEntity = entity
    }
    
    func animate(){
        let animations = self.modelEntity.availableAnimations
        if animations.count == 1{
            self.modelEntity.playAnimation(animations[0].repeat(duration: .infinity), transitionDuration: 0, startsPaused: false)
                    print("animation is playing")
        }
        
    }
}
