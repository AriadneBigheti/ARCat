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
        self.scaleCompensation = 2
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
                self.modelEntity?.scale = .init(repeating: FocusEntity.size*4)
                
                print("loaded model")
                
                cancellable?.cancel()

            })
    }
    
    func animate(){
        let animations = self.modelEntity?.availableAnimations
        self.modelEntity?.playAnimation(animations![0].repeat(duration: .infinity), transitionDuration: 0, startsPaused: false)
                print("animation is playing")
        
    }
    
    func moveCat(){
        var modelTransform = self.modelEntity?.transform
        modelTransform?.translation = [0, 0, 0.3]
        animate()
        modelEntity?.move(to: modelTransform!, relativeTo: modelEntity?.parent, duration: 0.5, timingFunction: .easeInOut)
        
    }
    
    func explore(){
        print("exploring")
    }
    
    func playFun(){
        print("playing")
    }
    
    func place(in arView: CustomARView){
        arView.placeModel(self.modelEntity!)
    }
}
