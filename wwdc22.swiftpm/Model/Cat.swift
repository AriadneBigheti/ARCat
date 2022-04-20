//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 12/04/22.
//

import RealityKit
import Combine

class Cat{
    var modelEntity: Entity?
    var scaleCompensation: Float
    
    init(view: CustomARView){
        self.scaleCompensation = 0.85
        asyncloadModel(arView: view)
    }
    
    func asyncloadModel(arView: CustomARView){
        var cancellable: AnyCancellable? = nil
        
        cancellable = Entity.loadAsync(named: "Bengal")
            .sink(receiveCompletion: { error in
                
                print("Error: \(error)")
                cancellable?.cancel()
                
            }, receiveValue: { [self] modelEntity in
                
                modelEntity.scale *= self.scaleCompensation
                modelEntity.generateCollisionShapes(recursive: true)
                
                self.modelEntity = modelEntity.clone(recursive: true)
                self.modelEntity?.generateCollisionShapes(recursive: true)

                print("loaded model")
                
                cancellable?.cancel()

            })
    }
    
    func animate(){
        let animations = self.modelEntity?.availableAnimations
        for animation in animations! {
            self.modelEntity?.playAnimation(animation.repeat(duration: .infinity), transitionDuration: 0.5, startsPaused: false)
                print("animation is playing")
        }
    }
    
    func moveCat(){
        var modelTransform = self.modelEntity?.transform
        modelTransform?.translation = [0, 0, 0.5]
        modelEntity?.move(to: modelTransform!, relativeTo: modelEntity?.parent, duration: 1, timingFunction: .easeInOut)
        animate()
        
    }
    
    func place(in arView: CustomARView){
        arView.placeModel(self.modelEntity!)
    }
}
