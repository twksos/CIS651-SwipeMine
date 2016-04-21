import UIKit

class MineCell: UILabel {
    //icon for flag
    let FLAG = "🚩"
    //icon for mine and texts
    let texts = [
        -1 : "💣",
        0  : "",
        1  : "1",
        2  : "2",
        3  : "3",
        4  : "4",
        5  : "5",
        6  : "6",
        7  : "7",
        8  : "8",
    ]
    //color for different surround number
    let colors = [
        1  : UIColor.blueColor(),
        2  : UIColor.greenColor(),
        3  : UIColor.redColor(),
        4  : UIColor.blackColor(),
        5  : UIColor.brownColor(),
        6  : UIColor.orangeColor(),
        7  : UIColor.purpleColor(),
        8  : UIColor.magentaColor(),
    ]
    //surround MineCells
    var surround = Set<MineCell>();
    //callback for report dig/flag to MineView
    var callback: ((Bool)->())?;
    //state of MineCells can be hide/flag/show
    var state = "hide";
    //mark = -1 means mine otherwise means surround number
    var mark = 0
    //freeze actions after win or lose
    var freezed:Bool = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //just show all mine after lose
    func showBomb() {
        if(self.mark == -1) {
            self.state = "show"
        }
        show()
    }
    //set freeze to true
    func freeze(){
        self.freezed = true
    }
    //dig a MineCell
    func dig() {
        //should not dig if freezed
        if(freezed) {return}
        //just dig hide block
        if(state == "hide") {
            //turn to show
            state = "show"
            //change background color to white
            backgroundColor = UIColor.whiteColor()
            
            //change background color to red if struck
            if(isTriggered()){
                backgroundColor = UIColor.redColor()
            }
            
            //if no surrounding mine, dig the surround MineCells
            if(mark == 0) {
                for cell in surround {
                    cell.dig()
                }
            }
            
            //report struck or not to MineView
            callback!(isTriggered())
        }
        //display new text if necessary
        show()
    }
    func toggleFlag() {
        //should not flag if freezed
        if(freezed) {return}
        
        //toggle flag
        if(state == "hide"){
            state = "flag"
        } else if(state == "flag") {
            state = "hide"
        }
        //report to MineView
        callback!(isTriggered())
        //display new text if necessary
        show()
    }
    
    //whether the MineCell is correctly flagged
    func isCorrectFlag()->Bool {
        return (self.state == "flag" && self.mark == -1) || (self.state != "flag" && self.mark != -1)
    }
    
    //whether the MineCell is correctly digged
    func isCorrectDig()->Bool {
        return (self.state == "show" && self.mark != -1) || (self.state != "show" && self.mark == -1)
    }
    
    //whether the MineCell is struck
    func isTriggered()->Bool {
        return self.state == "show" && self.mark == -1
    }
    
    //init a mine block
    func setMine(mark:Int, callback: (Bool)->()) {
        //set mark, callback, reset freezed
        self.mark = mark
        self.callback = callback
        self.freezed = false
        
        //set border
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        
        //set default/hide background
        self.backgroundColor = UIColor.grayColor()
        //text should align center
        self.textAlignment = NSTextAlignment.Center
        //set text color
        self.textColor = colors[mark]
        
        
        //set tap actions
        self.userInteractionEnabled = true
        
        //double tap for dig
        let doubleTap = UITapGestureRecognizer(target: self, action: "dig")
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        //single tap for flag
        let singleTap = UITapGestureRecognizer(target: self, action: "toggleFlag")
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
        
        //single tap should be trigger if double tap timeout
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        //display new text if necessary
        self.show()
    }
    
    func show() {
        //show icon or text if state is show
        if(self.state == "show") {
            self.text = texts[mark]
        }
        //show nothing if state is hide
        if(self.state == "hide") {
            self.text = ""
        }
        
        
//        self.text = texts[mark]  //cheat and test
        //show flag if state is hide
        if(self.state == "flag") {
            self.text = FLAG
        }
        
        
    }
}
