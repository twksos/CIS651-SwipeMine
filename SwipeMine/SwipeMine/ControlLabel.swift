import UIKit

class ControlLabel: UILabel {
    //states dict with correspoding icon
    let states = [
        "play" : "😶",
        "win"  : "😃",
        "lose" : "😲",
    ]
    
    required override init(frame f: CGRect) {
        super.init(frame: f)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //set icon using game state
    func setIcon(state:String) {
        self.text = states[state];
    }
}
