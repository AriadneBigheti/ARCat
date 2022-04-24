//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//
import RealityKit
import Combine

class BallonComponent: Component{
    var modelEntity: Entity?
    var fileName: String
    var hasAppered: Bool = false
    var scale: Float
    
    init(view: CustomARView, fileName: String, scale: Float){
        self.fileName = fileName
        self.scale = scale
        asyncloadModel(arView: view)
        
    }
    
    func asyncloadModel(arView: CustomARView){
        var cancellable: AnyCancellable? = nil
        
        cancellable = Entity.loadAsync(named: fileName)
            .sink(receiveCompletion: { error in
                
                print("Error: \(error)")
                cancellable?.cancel()
                
            }, receiveValue: { [self] model in
                
                modelEntity = model.clone(recursive: true)
                modelEntity?.generateCollisionShapes(recursive: true)
                modelEntity?.scale = .init(repeating: scale)

                print("loaded model")
                
                cancellable?.cancel()

            })
    }
    
    func place(in entity: Entity){
        if let model = self.modelEntity{
            model.position = entity.position
            model.position.y -= 0.4
            entity.addChild(model)
        }
    }
    
    func remove(){
        modelEntity?.removeFromParent()
    }
    
    func animate(){
        var modelTransform = self.modelEntity?.transform
        modelTransform?.translation = [-2, 0, 0]
        modelEntity?.move(to: modelTransform!, relativeTo: modelEntity?.parent, duration: 0.7, timingFunction: .easeInOut)
    }
         
}
