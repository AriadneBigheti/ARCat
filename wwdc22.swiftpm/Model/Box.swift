//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//
import RealityKit
import Combine

class Box{
    var modelEntity: Entity?
    var scaleCompensation: Float
    var isPlaced = false

    
    init(view: CustomARView){
        self.scaleCompensation = 4
        asyncloadModel(arView: view)
    }
    
    func asyncloadModel(arView: CustomARView){
        var cancellable: AnyCancellable? = nil
        
        cancellable = Entity.loadAsync(named: "box")
            .sink(receiveCompletion: { error in
                
                print("Error: \(error)")
                cancellable?.cancel()
                
            }, receiveValue: { [self] modelEntity in
                
                modelEntity.scale *= self.scaleCompensation
                modelEntity.generateCollisionShapes(recursive: true)
                self.modelEntity = modelEntity.clone(recursive: true)

                print("loaded model")
                
                cancellable?.cancel()

            })
    }
    
    func place(in arView: CustomARView){
            arView.placeModel(self.modelEntity!)
            self.isPlaced = true
    }
    
    func rotateBox(){
        var flipDownTransformation = self.modelEntity?.transform
        flipDownTransformation?.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        modelEntity?.move(to: flipDownTransformation!, relativeTo: modelEntity?.parent, duration: 1.2, timingFunction: .easeInOut)
    }
}
