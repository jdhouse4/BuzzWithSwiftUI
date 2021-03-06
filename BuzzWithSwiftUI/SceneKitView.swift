//
//  SceneKitView.swift
//  BuzzWithSwiftUI
//
//  Created by James Hillhouse IV on 9/2/19.
//  Copyright © 2019 PortableFrontier. All rights reserved.
//

import SwiftUI
import SceneKit
import SpriteKit
import GLKit




struct SceneKitView: UIViewRepresentable {


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch)
    }


    @Binding var lightSwitch: Bool
    @Binding var sunlightSwitch: Int
    @Binding var bodyCameraSwitch: Bool


    // SceneKit Properties
    let scene = SCNScene(named: "BuzzWithSwiftUISCNAssets.scnassets/Buzz.scn")!

    //var sunlightNode: SCNNode = SCNNode()

    var lightTextNode: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue")

    var overlayScene: SKScene = SKScene()



    func makeUIView(context: Context) -> SCNView {
        print("SceneKitView makeUIView")
        // retrieve the SCNView
        let scnView = SCNView()

        // configure the view
        scnView.backgroundColor = UIColor.black

        // WorldCamera from scn file.
        scnView.pointOfView = scene.rootNode.childNode(withName: "WorldCamera", recursively: true)

        // Now, using WorldLight from scn file.
        let worldLight  = scene.rootNode.childNode(withName: "SunLight", recursively: true)!

        
        // This code is needed for placing the overlay text.
        let screenSize: CGSize =  UIScreen.main.bounds.size

        // Find the center of the screen
        let screenCenter: CGPoint = CGPoint(x: screenSize.width/2, y: screenSize.height/2)

        // Give the overlayScene property a size.
        overlayScene.size = CGSize(width: screenSize.width, height: screenSize.height)


        // Add-in SKLabelNode for the light currently in use
        lightTextNode.name = "SunlightTypeTextNode"
        lightTextNode.text = worldLight.light!.type.rawValue
        lightTextNode.fontSize = 30
        lightTextNode.fontColor = .white
        lightTextNode.position = CGPoint(x: screenCenter.x, y:  50)
        overlayScene.addChild(lightTextNode)

        scnView.overlaySKScene = overlayScene


        // Double-Tap Gesture Recognizer to Reset Orientation of the Model
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.triggerDoubleTapAction(gestureReconizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(doubleTapGestureRecognizer)


        let panGestureRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.panGesture(_:)))
        scnView.addGestureRecognizer(panGestureRecognizer)

        return scnView
    }



    func updateUIView(_ scnView: SCNView, context: Context) {
        print("SceneKitView updateUIView(_:SCNView, Context)")
        
        // set the scene to the view
        scnView.scene = scene

        scnView.backgroundColor = UIColor.black

        scnView.allowsCameraControl = false

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        toggleBuzzFaceLamp(scnView)

        toggleSunlight(scnView)

        toggleBuzzBodyCamera(scnView)
    }


    
    func toggleBuzzFaceLamp(_ scnView: SCNView) {
        guard let lightNode = scnView.scene!.rootNode.childNode(withName: "BuzzFaceLight", recursively: true) else { return }

        lightNode.isHidden = lightSwitch
    }



    func toggleSunlight(_ scnView: SCNView) {
        //var sunlightNode = scnView.scene!.rootNode.childNode(withName: "WorldLight", recursively: true)
        guard let worldLight = scnView.scene!.rootNode.childNode(withName: "SunLight", recursively: true) else { return }

        switch sunlightSwitch {
        case 0:
            worldLight.light?.type = .directional
            lightTextNode.text = worldLight.light?.type.rawValue
        case 1:
            worldLight.light?.type = .spot
            lightTextNode.text = worldLight.light?.type.rawValue
        case 2:
            worldLight.light?.type = .omni
            lightTextNode.text = worldLight.light?.type.rawValue
        case 3:
            worldLight.light?.type = .ambient
            lightTextNode.text = worldLight.light?.type.rawValue
        default:
            worldLight.light?.type = .directional
            lightTextNode.text = worldLight.light?.type.rawValue
        }
    }



    func toggleBuzzBodyCamera(_ scnView: SCNView) {
        if bodyCameraSwitch == true {
            scnView.pointOfView = scnView.scene?.rootNode.childNode(withName: "BodyCamera", recursively: true)
        } else {
            scnView.pointOfView = scnView.scene?.rootNode.childNode(withName: "WorldCamera", recursively: true)
        }
    }



    
    class Coordinator: NSObject {

        @Binding var lightSwitch: Bool
        @Binding var sunlightSwitch: Int

        var scnView: SceneKitView

        var totalChangePivot = SCNMatrix4Identity


        init(_ scnView: SceneKitView, lightSwitch: Binding<Bool>, sunlightSwitch: Binding<Int>) {
            self.scnView            = scnView
            self._lightSwitch       = lightSwitch
            self._sunlightSwitch    = sunlightSwitch
        }



        // Double-Tap Action
        @objc func triggerDoubleTapAction(gestureReconizer: UITapGestureRecognizer) {

            guard let buzzNode = self.scnView.scene.rootNode.childNode(withName: "Buzz", recursively: true) else{
                print("There's no Buzz Node!")
                return
            }

            let currentPivot    = buzzNode.pivot
            //print("currentPivot: \(currentPivot)")

            let changePivot     = SCNMatrix4Invert( totalChangePivot )
            //print("changePivot = \(changePivot)")

            buzzNode.pivot      = SCNMatrix4Mult(changePivot, currentPivot)

            totalChangePivot    = SCNMatrix4Identity
        }


        @objc func panGesture(_ gestureRecognize: UIPanGestureRecognizer){
            print("SceneKitView Coordinator panGesture")

            let translation = gestureRecognize.translation(in: gestureRecognize.view!)

            let x = Float(translation.x)
            let y = Float(-translation.y)

            let anglePan = sqrt(pow(x,2)+pow(y,2)) * (Float)(Double.pi) / 180.0

            guard let buzzNode = self.scnView.scene.rootNode.childNode(withName: "Buzz", recursively: true) else{
                print("There's no Buzz Node!")
                return
            }

            var rotationVector = buzzNode.rotation // SCNVector4()
            rotationVector.x = -y
            rotationVector.y = x
            rotationVector.z = 0
            rotationVector.w = anglePan

            buzzNode.rotation = rotationVector

            if(gestureRecognize.state == UIGestureRecognizer.State.ended) {

                let currentPivot = buzzNode.pivot
                let changePivot = SCNMatrix4Invert( buzzNode.transform)

                totalChangePivot = SCNMatrix4Mult(changePivot, currentPivot)
                buzzNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)

                buzzNode.transform = SCNMatrix4Identity
            }
        }
    }
}
