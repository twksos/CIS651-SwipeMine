import UIKit

class MineViewController: UIViewController {
    //2d array to store mine position and surround numbers
    private var mines = [[Int]](count:16, repeatedValue: [Int](count:16, repeatedValue: 0));

    //mine view for display mine blocks
    @IBOutlet var mineView: MineView!
    //state button for display game state and reset game
    @IBOutlet weak var stateButton: ControlLabel!
    
    //after view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //single tap on state button will trigger new game start
        let singleTap = UITapGestureRecognizer(target: self, action: "startNewGame")
        singleTap.numberOfTapsRequired = 1
        stateButton.addGestureRecognizer(singleTap)
        
        //start new game
        startNewGame()
    }
    
    //start a new game
    func startNewGame(){
        //clear all existing mines with their surround number
        clearMines()
        //generate new mines with surround number
        generateMines()
        //set state button to play
        stateButton.setIcon("play")
        //get bounds
        let bounds = self.view.bounds
        //construct a mineView
        mineView.construct(bounds, mines: self.mines, callback: self.resultListener)
    }
    
    //being called by mineView when there is a result
    func resultListener(win:Bool) {
        if(win) {
            //set state button to win if won
            stateButton.setIcon("win")
        } else {
            //set state button to lose if lost
            stateButton.setIcon("lose")
        }
    }
    
    //add surround number for a position
    func addNumber(x: Int, y:Int){
        //if out of bound just return
        if(x < 0 || x >= 16 || y < 0 || y >= 16){
            return
        }
        
        //if there is no mine, add surround number
        if(self.mines[x][y] != -1) {
            self.mines[x][y] = self.mines[x][y] + 1
        }
    }
    //clear all mines
    func clearMines(){
        for i in 0..<16 {
            for j in 0..<16 {
                //set all mines to 0
                mines[i][j] = 0
            }
        }
    }
    
    //generate mines
    func generateMines(){
        //init a set for mine
        var minePoints = Set<Int>()
        //insert 45 different points in 16 * 16 grid
        while minePoints.count < 45 {
            minePoints.insert(Int(arc4random_uniform(256)))
        }
        //set mine points and calculate numbers
        for i in minePoints {
            //calculate x, y
            let x = i % 16
            let y = (i - x)/16
            
            //set mine for current block
            mines[x][y] = -1
            
            //add 1 to 8 surround blocks
            addNumber(x-1, y: y-1)
            addNumber(x-1, y: y)
            addNumber(x-1, y: y+1)
            
            addNumber(x, y: y-1)
            addNumber(x, y: y+1)
            
            addNumber(x+1, y: y-1)
            addNumber(x+1, y: y)
            addNumber(x+1, y: y+1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}