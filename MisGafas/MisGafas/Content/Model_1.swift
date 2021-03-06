//
//  Model_1.swift
//  MisGafas
//
//  Created by Rodolfo Ortiz on 19/02/20.
//  Copyright © 2020 Rodolfo Ortiz. All rights reserved.
//

import ARKit
import SceneKit

class SunglassesModel1: SCNNode {
    
    let occlusionNode: SCNNode
    var model = String("Model 1")
    
    init(geometry: ARSCNFaceGeometry) { //Takes the user’s face geometry as a parameter
        geometry.firstMaterial!.colorBufferWriteMask = []
        occlusionNode = SCNNode(geometry: geometry)
        occlusionNode.renderingOrder = -1 //Material render depth but not color
        
        super.init()
        
        addChildNode(occlusionNode) //Add occlusionNode to the scene
        
        guard let url = Bundle.main.url(forResource: "sunglasses1", withExtension: "scn", subdirectory: "SunglassesModels.scnassets/Model1") else {
            fatalError("Missing source")
        } //Check to make sure xxx.scn exists in the main bundle.
        
        let node = SCNReferenceNode(url: url)!
        node.load() //Create a reference node and load it
        
        addChildNode(node) //Add everything from the scene file into the scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        let faceGeometry = occlusionNode.geometry as! ARSCNFaceGeometry
        faceGeometry.update(from: anchor.geometry)
    }
}
