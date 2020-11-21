
/// Class for calculating longest common subsequence problems using dynamic programming
class LCS {
    // Helper constants to be used when backtracing the dynamic programming table
    private let UP: Int = 1
    private let LEFT: Int = 2
    private let DIAG: Int = 3
    private let BOTH: Int = 4
    
    /// LCS Constructor
    init() {}
    
    /// Gets a longest common subsequence of two strings
    ///     Runs in O(mn) time with O(mn) space
    func getLCS(s1: String, s2: String) -> String {
        let length1: Int = s1.characters.count
        let length2: Int = s2.characters.count
        
        // Array should have an extra column and row to keep logic simple
        var arr: [[(counter: Int, direction: Int)]] =
            Array(count: length1 + 1, repeatedValue: Array(count: length2 + 1, repeatedValue: (0, 0)))
        
        // Fill array and start at 1, 1 for extra zeroed column and row
        for y in 1...length2 {
            for x in 1...length1 {
                // Check if the two strings match at x and y locations in the strings
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
        
        // Backtrace through array to find a valid LCS
        var position: (x: Int, y: Int) = (length1, length2)
        var toReturn: String = ""
        while true {
            // No more common characters to check
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
    
    /// Gets the length of a longest common subsequence of two strings
    ///     Runs in O(mn) time with O(min{m, n}) space
    func getLCSLength(s1: String, s2: String) -> Int {
        let length1: Int = s1.characters.count
        let length2: Int = s2.characters.count
        
        // Make sure that A string and A length are smaller than B
        let ordered: Bool = length1 < length2
        let sA: String = ordered ? s1 : s2
        let sB: String = ordered ? s2 : s1
        let lengthA: Int = ordered ? length1 : length2
        let lengthB: Int = ordered ? length2 : length1
        
        // Array should have an extra column to keep logic simple
        //  and only two rows need to be made to just find the length
        var arr: [[Int]] = Array(count: lengthA + 1, repeatedValue: Array(count: 2, repeatedValue: 0))
        
        // Fill array and start at 1 for extra zeroed column
        for y in 1...lengthB {
            for x in 1...lengthA {
                // Check if the two strings match at x and y locations in the strings
                if sA[sA.startIndex.advancedBy(x - 1)] == sB[sB.startIndex.advancedBy(y - 1)] {
                    arr[x][y % 2] = arr[x - 1][(y - 1) % 2] + 1
                }
                else if arr[x - 1][y % 2] > arr[x][(y - 1) % 2] {
                    arr[x][y % 2] = arr[x - 1][y % 2]
                }
                else {
                    arr[x][y % 2] = arr[x][(y - 1) % 2]
                }
            }
        }
        
        return arr[lengthA][lengthB % 2]
    }
    
    /// Gets a longest increasing subsequence of a string
    ///     Uses LCS to run in O(n^2) time with O(n^2) space
    func getLIS(s1: String) -> String {
        return getLCS(s1, s2: String(s1.characters.sort()))
    }
}

// Testing LCS class
var lcs: LCS = LCS()
lcs.getLCS("CTAGACATAGGAT", s2: "TAGACATAACCAG")
lcs.getLCSLength("CTAGACATAGGAT", s2: "TAGACATAACCAG")
lcs.getLIS("ABDCFHBACHDC")

