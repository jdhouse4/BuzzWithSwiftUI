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




struct SceneKitView: UIViewRepresentable {


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, lightSwitch: $lightSwitch, sunlightSwitch: $sunlightSwitch)
    }


    @Binding var lightSwitch: Bool
    @Binding var sunlightSwitch: Int


    // SceneKit Properties
    let scene = SCNScene(named: "Buzz.scn")!

    var sunlightNode: SCNNode = SCNNode()

    var lightTextNode: SKLabelNode = SKLabelNode(fontNamed: "HelveticaNeue")

    var overlayScene: SKScene = SKScene()



    func makeUIView(context: Context) -> SCNView {
        // retrieve the SCNView
        let scnView = SCNView()


        // configure the view
        scnView.backgroundColor = UIColor.black


        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // Place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0.0, z: 20)

        // Configure camera within view
        scnView.pointOfView = cameraNode


        // Create sunlight node to shine a little light on the whole scene.
        sunlightNode.name = "ChangingLightNode"
        sunlightNode.light = SCNLight()
        sunlightNode.light!.type = .directional
        sunlightNode.light!.intensity = 500.0
        sunlightNode.light!.categoryBitMask = 2
        sunlightNode.light!.castsShadow = true
        sunlightNode.position = SCNVector3(x: 0.0, y: 8.0, z: 15)
        scene.rootNode.addChildNode(sunlightNode)


        // This code is needed for placing the overlay text.
        let screenSize: CGSize =  UIScreen.main.bounds.size

        // Find the center of the screen
        let screenCenter: CGPoint = CGPoint(x: screenSize.width/2, y: screenSize.height/2)

        // Give the overlayScene property a size.
        overlayScene.size = CGSize(width: screenSize.width, height: screenSize.height)


        // Add-in SKLabelNode for the light currently in use
        lightTextNode.name = "SunlightTypeTextNode"
        lightTextNode.text = sunlightNode.light!.type.rawValue
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
        // set the scene to the view
        scnView.scene = scene

        scnView.backgroundColor = UIColor.black

        scnView.allowsCameraControl                                 = false
        //scnView.cameraControlConfiguration.autoSwitchToFreeCamera   = false
        //scnView.cameraControlConfiguration.allowsTranslation        = false

        // show statistics such as fps and timing information
        scnView.showsStatistics = true

        toggleBuzzFaceLamp(scnView)

        toggleSunlight(scnView)
    }


    
    func toggleBuzzFaceLamp(_ scnView: SCNView) {
        let lightNode = scnView.scene!.rootNode.childNode(withName: "BuzzFaceLight", recursively: true)

        lightNode!.isHidden = lightSwitch
    }



    func toggleSunlight(_ scnView: SCNView) {
        switch sunlightSwitch {
        case 0:
            sunlightNode.light?.type = .directional
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 1:
            sunlightNode.light?.type = .spot
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 2:
            sunlightNode.light?.type = .omni
            lightTextNode.text = sunlightNode.light?.type.rawValue
        case 3:
            sunlightNode.light?.type = .ambient
            lightTextNode.text = sunlightNode.light?.type.rawValue
        default:
            sunlightNode.light?.type = .directional
            lightTextNode.text = sunlightNode.light?.type.rawValue
        }
    }



    
    class Coordinator: NSObject {

        @Binding var lightSwitch: Bool
        @Binding var sunlightSwitch: Int

        var scnView: SceneKitView

        init(_ scnView: SceneKitView, lightSwitch: Binding<Bool>, sunlightSwitch: Binding<Int>) {
            self.scnView = scnView
            self._lightSwitch = lightSwitch
            self._sunlightSwitch = sunlightSwitch
        }



        // Double-Tap Action
        @objc func triggerDoubleTapAction(gestureReconizer: UITapGestureRecognizer) {

            guard let buzzNode = self.scnView.scene.rootNode.childNode(withName: "Buzz", recursively: true) else{
                print("There's no Buzz Node!")
                return
            }

            let currentPivot = buzzNode.pivot
            //print("Buzz pivot: \(buzzNode.pivot)")

            let changePivot = SCNMatrix4Invert( totalChangePivot )

            buzzNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)
            //print("Buzz pivot post SCNMatrix4Mult: \(buzzNode.pivot)")

            // For some reason, setting m11, m22, m33 to 1.0 zooms the camera. This is a hack that fixes that issue.
            buzzNode.transform.m11 = 0.5
            buzzNode.transform.m22 = 0.5
            buzzNode.transform.m33 = 0.5
        }



        // Pan Action
        var initialCenter = CGPoint()  // The initial center point of the view.

        @objc func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
            guard gestureRecognizer.view != nil else {return}

            let piece = gestureRecognizer.view!

            // Get the changes in the X and Y directions relative to the superview's coordinate space.
            let translation = gestureRecognizer.translation(in: piece.superview)

            if gestureRecognizer.state == .began {

                // Save the view's original position.
              self.initialCenter = piece.center
            }

            // Update the position for the .began, .changed, and .ended states
            if gestureRecognizer.state != .cancelled {
              // Add the X and Y translation to the view's original position.
              let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
              piece.center = newCenter
            }
           else {
              // On cancellation, return the piece to its original location.
              piece.center = initialCenter
           }
        }


        var totalChangePivot = SCNMatrix4Identity

        @objc func panGesture(_ gestureRecognize: UIPanGestureRecognizer){

            let translation = gestureRecognize.translation(in: gestureRecognize.view!)

            let x = Float(translation.x)
            let y = Float(-translation.y)

            let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(Double.pi)/180.0

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
