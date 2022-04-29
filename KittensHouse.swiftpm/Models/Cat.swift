//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 12/04/22.
//

import RealityKit
import Combine
import SwiftUI
import ARKit
import UIKit

class Cat{
    var modelEntity: Entity?
    var scaleCompensation: Float
    var modelFile: String
    var modelName: String
    var scaleParameter = 0.17
    var scale: Float
    var arView: CustomARView
    var ballonName: String
   
    init(view: CustomARView, name: String, modelFile: String, scale: Float, ballonName: String){
        self.scaleCompensation = scale
        self.arView = view
        self.modelName = name
        self.modelFile = modelFile
        self.scale = scale
        self.ballonName = ballonName
        asyncloadModel(arView: view)
    }
    
    func asyncloadModel(arView: CustomARView){
        var cancellable: AnyCancellable? = nil
        
        cancellable = Entity.loadAsync(named: modelFile)
            .sink(receiveCompletion: { error in
                
                print("Error: \(error)")
                cancellable?.cancel()
                
            }, receiveValue: { [self] modelEntity in
                
                modelEntity.scale *= self.scaleCompensation
                modelEntity.generateCollisionShapes(recursive: true)
                
                self.modelEntity = modelEntity.clone(recursive: true)
                self.modelEntity?.generateCollisionShapes(recursive: true)
                self.modelEntity?.scale = .init(repeating: Float(scaleParameter)*scale)
                self.modelEntity?.name = modelName
                self.modelEntity?.components[BallonComponent.self] = BallonComponent(view: arView, fileName: ballonName, scale: scale)
                                
                cancellable?.cancel()
            })
    }
    
    func animate(){
        let animations = self.modelEntity?.availableAnimations
        if animations?.count == 1{
            self.modelEntity?.playAnimation(animations![0].repeat(duration: .infinity), transitionDuration: 0, startsPaused: false)
        }
    }
    
    func place(in arView: CustomARView){
        arView.placeModel(self.modelEntity!)
    }
}
