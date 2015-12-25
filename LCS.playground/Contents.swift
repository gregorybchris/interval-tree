class LCS {
    private let UP: Int = 1
    private let LEFT: Int = 2
    private let DIAG: Int = 3
    private let BOTH: Int = 4
    
    init() {}
    
    func getLCS(s1: String, s2: String) -> String {
        let length1: Int = s1.characters.count
        let length2: Int = s2.characters.count
        var arr: [[(counter: Int, direction: Int)]] =
            Array(count: length1 + 1, repeatedValue: Array(count: length2 + 1, repeatedValue: (0, 0)))
        
        for y in 1...length2 {
            for x in 1...length1 {
                if s1[s1.startIndex.advancedBy(x - 1)] == s2[s2.startIndex.advancedBy(y - 1)] {
                    arr[x][y] = (arr[x - 1][y - 1].counter + 1, DIAG)
                }
                else if arr[x - 1][y].counter > arr[x][y - 1].counter {
                    arr[x][y] = (arr[x - 1][y].counter, LEFT)
                }
                else if arr[x - 1][y].counter < arr[x][y - 1].counter {
                    arr[x][y] = (arr[x][y - 1].counter, UP)
                }
                else {
                    arr[x][y] = (arr[x][y - 1].counter, BOTH)
                }
            }
        }
        
        var position: (x: Int, y: Int) = (length1, length2)
        var toReturn: String = ""
        while true {
            if position.x == 0 || position.y == 0 {
                break
            }
            
            let currentDirection: Int = arr[position.x][position.y].direction
            if currentDirection == DIAG {
                toReturn = String(s1[s1.startIndex.advancedBy(position.x - 1)]) + toReturn
                position.x -= 1
                position.y -= 1
            }
            else if currentDirection == LEFT {
                position.x -= 1
            }
            else if currentDirection == UP || currentDirection == BOTH {
                position.y -= 1
            }
        }
        
        return toReturn
    }
    
    func getLIS(s1: String) -> String {
        s1.utf16.sort()
        return getLCS(s1, s2: String(s1.characters.sort()))
    }
}

var lcs = LCS()

lcs.getLCS("ABDCFHBACHDC", s2: "CDHCABHFCDBA")
lcs.getLIS("ABDCFHBACHDC")

