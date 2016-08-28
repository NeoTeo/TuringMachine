//: Turing machine playground

import Foundation

enum Movement {
	case left
	case right
}

/// A rule is a tuple that defines actions for output, movement, configuration change
typealias Rule = (Int?, Movement?, Int)

/// A configuration is a set of two rules,
/// one for the case we read 0 off the tape and one for the case of 1.
typealias configuration = (Rule, Rule)

func tm(configs: [configuration], tape: [Int], headStartPos: Int, startConfig: Int) -> [Int] {
	
	var tape = tape
	var configIdx = startConfig
	var head = headStartPos
	
	var oldOut: Int?
	var oldHead: Int
	var oldCfgIdx: Int
	
	/// Real Turing machine tape is infinite!
	while head < tape.count {
		
		/// First read the value on the tape at the position of head.
		let value = tape[head]
		
		/// Load the configuration for the current config index.
		let config = configs[configIdx]
		
		/// Fetch the rules for the given value read off the tape.
		let (ioAction, movement, newConfigIdx) = (value == 0) ? config.0 : config.1

		oldOut = ioAction
		/// Act on the rules:
		/// If an ioAction exists, write it to the tape at the current position.
		if let action = ioAction {
			tape[head] = action
		}

		oldHead = head
		/// If a movement is defined, move the head in the given direction.
		if let mov = movement { head += (mov == .left) ? -1 : 1 }
		
		oldCfgIdx = configIdx
		/// update the config
		configIdx = newConfigIdx

		/// Debug stuff
		if configIdx != oldCfgIdx {	print("configidx: \(configIdx)") }
		
		/// Here we could break if there have been no output, movement or config changes.
		if oldOut == ioAction && oldHead == head && oldCfgIdx == configIdx {
			break
		}
	}
	
	return tape
}

/// The table of behaviour is an array of configurations.
/// This particular tob adds two numbers by encoding the sum on the tape.
let tob: [configuration] = [
	((nil, .right, 0),(nil, .right,1)),
	((1, .right, 2),(nil, .right,1)),
	((nil, .left, 3),(nil, .right,2)),
	((nil, nil, 3),(0, .right,3)),
]

let myTape = [0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0]

let newTape = tm(configs: tob, tape: myTape, headStartPos: 0, startConfig: 0)

print(newTape)
