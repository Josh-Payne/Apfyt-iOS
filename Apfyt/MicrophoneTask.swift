//
//  MicrophoneTask.swift
//  Apfyt
//
//  Created by Josh Payne on 2/18/17.
//  Copyright © 2017 Apfyt. All rights reserved.
//

import ResearchKit

public var MicrophoneTask: ORKOrderedTask {
  return ORKOrderedTask.audioTask(withIdentifier: "AudioTask", intendedUseDescription: "A sentence prompt will be given to you to read.", speechInstruction: "These are the last dying words of Joseph of Aramathea", shortSpeechInstruction: "The Holy Grail can be found in the Castle of Aaaaaaaaaaah", duration: 10, recordingSettings: nil, options: ORKPredefinedTaskOption())
}
