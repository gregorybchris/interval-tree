/// A trip with a start time, end time, and assigned boat
class Trip {
    static var UNASSIGNED: Int = -1
    var interval: (start: Int, end: Int)
    var boat: Int
    
    init(interval: (start: Int, end: Int)) {
        self.interval = interval
        self.boat = Trip.UNASSIGNED
    }
}

/// A vertex of a graph that holds a trip
class Vertex {
    static var UNCOLORED: Int = -1
    var trip: Trip
    var adjacent: [Vertex] = [Vertex]()
    var color: Int
    var visited: Bool = false
    
    /// Vertex constructor
    init(trip: Trip) {
        self.trip = trip
        self.color = Vertex.UNCOLORED
    }
    
    /// Adds a vertex to this vertex's adjacent list
    ///     NOTE: this function does not check for and will add duplicate vertices
    func addEdge(vertex: Vertex) {
        adjacent.append(vertex)
    }
}

/// A graph that represents the overlapping of trips
///     Represented as an adjacency lists for efficiency of BFS and so that 
///     vertices can add edges between each other without referring to the graph
class Graph {
    private var vertices = [Vertex]()
    
    /// Graph constructor
    init() {}
    
    /// Adds a bidirectional edge between two given vertices
    ///     NOTE: Does not check that these two vertices are actually in the same graph
    func addEdge(v1: Vertex, v2: Vertex) {
        v1.addEdge(v2)
        v2.addEdge(v1)
    }
    
    /// Creates a vertex from a trip and adds it to the graph's vertex list
    ///     The newly created vertex is returned
    func addVertex(trip: Trip) -> Vertex {
        let newVertex = Vertex(trip: trip)
        vertices.append(newVertex)
        return newVertex
    }
    
    /// Colors the graph with a breadth first search
    ///     Returns the number of colors used in the coloring
    func color() -> Int {
        let queue: Queue = Queue()
        var colors: [Bool] = [Bool]()
        colors.append(false)
        // Make sure all unconnected components are traversed
        for vertex in vertices {
            if !vertex.visited {
                vertex.color = 0
                queue.push(vertex)
            }
            // BFS on the queue's current vertex
            while !queue.isEmpty() {
                colorVertex(queue.pop(), queue: queue, colors: &colors)
            }
        }
        
        return colors.count
    }
    
    /// Private helper method to color a vertex in the BFS of the color method
    private func colorVertex(vertex: Vertex, queue: Queue, inout colors: [Bool]) {
        vertex.visited = true
        // Mark all colors as used that are the colors of the neighbors
        for var i: Int = 0; i < colors.count; ++i {
            colors[i] = false
        }
        for neighbor in vertex.adjacent {
            if !neighbor.visited {
                queue.push(neighbor)
            }
            if neighbor.color != Vertex.UNCOLORED {
                colors[neighbor.color] = true
            }
        }
        // Figure out the first unused color and color the current vertex
        for var i: Int = 0; i < colors.count; ++i {
            if colors[i] == false {
                vertex.color = i
                break
            }
            // A new color needs to be added
            if i == colors.count - 1 {
                colors.append(false)
                vertex.color = colors.count - 1
            }
        }
    }
}

/// A queue to hold graph vertices for BFS
class Queue {
    var queue: [Vertex] = [Vertex]()
    
    /// Queue constructor
    init() {}
    
    /// Pushes the vertex onto the top of the queue
    func push(vertex: Vertex) {
        queue.append(vertex)
    }
    
    /// Takes the first element in the queue off and returns it
    func pop() -> Vertex {
        return queue.removeFirst()
    }
    
    /// Returns true if the queue is empty, otherwise false
    func isEmpty() -> Bool {
        return queue.isEmpty
    }
}

/// An interval tree used to find overlapping intervals made with an AVL tree
class IntervalTree {
    var vertex: Vertex
    var left: IntervalTree?
    var right: IntervalTree?
    var maxEnd: Int
    
    /// IntervalTree constructor
    init(vertex: Vertex) {
        self.vertex = vertex
        self.maxEnd = vertex.trip.interval.end
    }
    
    /// Adds edges between a given interval and all overlapping intervals in the tree
    ///     Then adds the interval to the tree
    func checkAndAdd(tree: IntervalTree) {
        check(tree)
        add(tree)
    }
    
    /// Private helper method that checks for overlapping intervals and
    private func check(tree: IntervalTree) {
        let thisStart: Int = self.vertex.trip.interval.start //3
        let thisEnd: Int = self.vertex.trip.interval.end //4
        let thisMax: Int = self.maxEnd // 5
        let newStart: Int = tree.vertex.trip.interval.start // 6
        let newEnd: Int = tree.vertex.trip.interval.end //15
        
        // Found an overlap
        if thisStart <= newEnd && newStart <= thisEnd {
            tree.vertex.addEdge(vertex)
            vertex.addEdge(tree.vertex)
        }
        
        // New interval can only overlap in left substree
        if newEnd < thisStart {
            if let leftSubtree = left {
                leftSubtree.check(tree)
            }
        }
        // New interval does not overlap any in the tree
        else if newStart > thisMax {
            return
        }
        // New interval could still potentially overlap all intervals in tree
        else {
            if let leftSubtree = left {
                leftSubtree.check(tree)
            }
            if let rightSubtree = right {
                rightSubtree.check(tree)
            }
        }
    }
    
    /// Private helper method that adds the interval to the tree
    private func add(tree: IntervalTree) {
        maxEnd = max(tree.vertex.trip.interval.end, maxEnd)
        
        // Interval should go in left subtree
        if tree.vertex.trip.interval.start < vertex.trip.interval.start {
            if let leftSubtree = left {
                leftSubtree.add(tree)
            }
            else {
                left = tree
            }
        }
        // Interval should go in right subtree
        else {
            if let rightSubtree = right {
                rightSubtree.add(tree)
            }
            else {
                right = tree
            }
        }
    }
}

// Create a list of trips; Should have IDs [0, 1, 0, 2]; Should be 3 colored
var trips: [Trip] = [
    Trip(interval: (3, 4)),
    Trip(interval: (1, 5)),
    Trip(interval: (6, 15)),
    Trip(interval: (2, 9))
]

// Create graph and interval tree and add in all trips as vertices
var graph: Graph = Graph()
var intervalTree: IntervalTree?
var vertices: [Vertex] = [Vertex]()
var someArr: [Int] = [Int]()
for trip in trips {
    let nextVertex = graph.addVertex(trip)
    vertices.append(nextVertex)
    
    // Add to interval tree if the tree has been created, otherwise create it
    if let tree = intervalTree {
        tree.checkAndAdd(IntervalTree(vertex: nextVertex))
    }
    else {
        intervalTree = IntervalTree(vertex: nextVertex)
    }
}

// Color the graph and get answer!
let totalColors = graph.color()
print("Total number of boats needed: " + String(totalColors))

// Iterate through vertices to figure out boat IDs based on vertex colors
var boats: [Int] = [Int]()
for vertex in vertices {
    vertex.trip.boat = vertex.color
    boats.append(vertex.color)
}
print("Possible boat IDs for each trip: " + String(boats))
