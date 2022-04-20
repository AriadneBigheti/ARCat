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
    var occlusionBox: ModelEntity?
    
    init(view: CustomARView){
        self.scaleCompensation = 4
        asyncloadModel(arView: view)
    }
    
    func asyncloadModel(arView: CustomARView){
        var cancellable: AnyCancellable? = nil
        
        cancellable = Entity.loadAsync(named: "newbox")
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
            //generateOcclusionBox()
            self.isPlaced = true
    }
    func rotateBox(){
        var flipDownTransformation = self.modelEntity?.transform
        flipDownTransformation?.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        modelEntity?.move(to: flipDownTransformation!, relativeTo: modelEntity?.parent, duration: 1.2, timingFunction: .easeInOut)
    }
    
    
     func generateOcclusionBox(){
         let material = OcclusionMaterial()
         let boxSize: Float = 0.2
         let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
         self.occlusionBox = ModelEntity(mesh: occlusionBoxMesh, materials: [material])
        
         self.occlusionBox?.position.z = -3*boxSize/4
         
         let planeMaterial = SimpleMaterial(color: .yellow, isMetallic: false)
         let planeMesh = MeshResource.generateBox(width: 0.01, height: 0.002, depth: 0.01)
         let plane = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
         plane.position.z = -3*boxSize/4
         
         self.modelEntity?.addChild(self.occlusionBox!)
         self.modelEntity?.addChild(plane)
         
     }
     
}
