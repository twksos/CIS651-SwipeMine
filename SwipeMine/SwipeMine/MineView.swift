import UIKit

class MineView: UIView {
    //demensions for split grids
    var deviceWidth : CGFloat = 0;
    var deviceHeight : CGFloat = 0;
    
    // width and height of cell
    var dw : CGFloat = 0;  var dh : CGFloat = 0
    
    //callback from MineViewController
    var callback: ((Bool)->())?
    //top space for ControlLabel/state button
    var topHeight:CGFloat = CGFloat(60)

    //array of MineCells
    var cells : [[MineCell?]] = [[MineCell?]](count:16, repeatedValue: [MineCell?](count: 16, repeatedValue: nil))
    
    override init(frame: CGRect) {
        print( "init(frame)" )
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        print( "init(coder)" )
        super.init(coder: aDecoder)
    }
    
    //add a cell to surround of another cell
    func addSurround(cell: MineCell, x:Int, y:Int){
        //if out of bound just return
        if(x < 0 || x >= 16 || y < 0 || y >= 16){
            return
        }
        //add surround
        cell.surround.insert(cells[x][y]!)
    }
    
    //judge whether win
    func isWin() -> Bool{
        //can win by flag every mine
        var winByFlag = true
        //can win by dig all non-mine
        var winByDig  = true
        for i in 0..<16 {
            for j in 0..<16 {
                let cell = cells[i][j]
                //all flag correctly
                winByFlag = winByFlag && cell!.isCorrectFlag()
                //or all dig correctly
                winByDig  = winByDig  && cell!.isCorrectDig()
            }
        }
        //either can be consider win
        return winByFlag || winByDig
    }
    
    //listen to MineCell actions flag/dig
    func resultListener(explode: Bool) {
        //dig and struck
        if(explode) {
            for i in 0..<16 {
                for j in 0..<16 {
                    let cell = cells[i][j]
                    //show all bomb
                    cell!.showBomb()
                    //freeze all cell
                    cell!.freeze()
                }
            }
            //let controller know
            callback!(false)
        } else {
            //when win
            if(isWin()) {
                for i in 0..<16 {
                    for j in 0..<16 {
                        let cell = cells[i][j]
                        //freeze all cell
                        cell!.freeze()
                    }
                }
                //let controller know
                callback!(true)
            }
        }
    }
    
    //construct new MineView for a new game
    func construct(bounds:CGRect, mines:[[Int]], callback: (Bool)->()) {
        //save callback and calculate cell size
        self.callback = callback
        self.deviceWidth = CGRectGetWidth( bounds )   // w = width of view (in points)
        self.deviceHeight = CGRectGetHeight( bounds ) // h = height of view (in points)
        self.dw = self.deviceWidth/16.0                      // dw = width of cell (in points)
        self.dh = (self.deviceHeight-topHeight)/16.0                     // dh = height of cell (in points)
        
        //create cells with mine data from controller, position and size data above
        for i in 0..<16 {
            for j in 0..<16 {
                let iF = CGFloat(i)
                let jF = CGFloat(j)
                //set position and size
                let cell = MineCell(frame: CGRectMake(iF * dw, jF * dh + topHeight, dw, dh))
                //set have mine or surround number
                cell.setMine(mines[i][j], callback: self.resultListener)
                //save cell for later use
                cells[i][j] = cell
                //add cell to view
                self.addSubview(cell)
            }
        }
        
        //add surround for each cell
        for i in 0..<16 {
            for j in 0..<16 {
                let cell = cells[i][j]
                addSurround(cell!, x: i-1, y: j-1)
                addSurround(cell!, x: i-1, y: j)
                addSurround(cell!, x: i-1, y: j+1)
                
                addSurround(cell!, x: i, y: j-1)
                addSurround(cell!, x: i, y: j+1)
                
                addSurround(cell!, x: i+1, y: j-1)
                addSurround(cell!, x: i+1, y: j)
                addSurround(cell!, x: i+1, y: j+1)
            }
        }
    }

}
