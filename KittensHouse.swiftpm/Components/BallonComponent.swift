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
                
                cancellable?.cancel()
            })
    }
    
    func place(in entity: Entity){
        if let model = self.modelEntity{
            model.position = entity.position
            entity.addChild(model)
            self.hasAppered = true
        }
    }
    
    func remove(){
        modelEntity?.removeFromParent()
    }
}
