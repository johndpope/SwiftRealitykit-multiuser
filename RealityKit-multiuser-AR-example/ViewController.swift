//
//  ViewController.swift
//  RealityKit-multiuser-AR-example
//
//  Created by sun on 5/4/2563 BE.
//  Copyright © 2563 sun. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupARView()
        
        arView.session.delegate = self
        
        // Add tapGesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupARView() {
        arView.automaticallyConfigureSession = false
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        config.isCollaborationEnabled = true
        
        arView.session.run(config)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        // anchor position is camera position
        let laserAnchor = ARAnchor(name: "LaserRed", transform: arView!.cameraTransform.matrix)
        arView.session.add(anchor: laserAnchor)
    }
    
    func placeObject(name entityName:String, for anchor: ARAnchor) {
        // Load entity
        let LaserEntity = try! ModelEntity.load(named: entityName)
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(LaserEntity)
        // add anchorEntity to scene
        arView.scene.addAnchor(anchorEntity)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // after 0.55 second remove anchorEntity
            self.arView.scene.removeAnchor(anchorEntity)
        }
        
    }
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            // if see anchor name LaserRed then add LaserRed Entity to scene
            if let anchorName = anchor.name, anchorName == "LaserRed" {
                placeObject(name: anchorName, for: anchor)
            }
        }
    }
}
