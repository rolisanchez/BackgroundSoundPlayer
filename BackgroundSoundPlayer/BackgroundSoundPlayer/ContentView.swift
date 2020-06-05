//
//  ContentView.swift
//  BackgroundSoundPlayer
//
//  Created by Victor Rolando Sanchez Jara on 6/5/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    // MARK: Properties
    @State private var timeElapsed = 0
    
    // MARK: Body
    var body: some View {
        Text("Time elapsed = \(timeElapsed)")
            .onAppear {
                self.startPlayingEmptySound()
        }
    }
    
    // MARK: Methods
    func startPlayingEmptySound() {
        // WARNING: Playing an Empty sound on background might cause Apple to reject an App submission
        // JUST FOR TEST PURPOSES!!
//        let soundFilePath = Bundle.main.path(forResource: "EmptySound.mp3", ofType:nil)!
                let soundFilePath = Bundle.main.path(forResource: "ShortWhiteNoise.mp3", ofType:nil)!
        
        let soundFileURL = URL(fileURLWithPath: soundFilePath)
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord)
            
            let emptyPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
            emptyPlayer.play()
            emptyPlayer.numberOfLoops = -1
            
            executeInBackground()
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    func executeInBackground() {
        print("executeInBackground")
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            print("Timer fired!")
            DispatchQueue.main.async {
                self.timeElapsed += 1
            }
            // Stop when reaching 10
            if self.timeElapsed < 10 {
                // Otherwise, check for conditions again
                self.executeInBackground()
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
