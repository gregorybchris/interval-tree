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
        //TODO: Do this
        let queue: Queue = Queue()
        queue.push(vertices[0])
        while !queue.isEmpty() {
            let currentVertex: Vertex = queue.pop()
            for neighbor in currentVertex.adjacent {
                if !neighbor.visited {
                    queue.push(neighbor)
                }
            }
        }
        
        return 0
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
    
    /// IntervalTree constructor
    init(vertex: Vertex) {
        self.vertex = vertex
    }
    
    /// Checks to see if the vertices overlap and if so adds an edge between them
    ///     Then recursively checks later vertices for an overlap and adds the vertex to the tree
    func checkAndAdd(vertex: Vertex) {
        //TODO: Do this
    }
}

// Create a list of trips
var trips: [Trip] = [Trip(interval: (3, 4)), Trip(interval: (1, 5)), Trip(interval: (6, 15)), Trip(interval: (7, 9))]

// The sorting function for trips
//func tripSorter(trip1: Trip, trip2: Trip) -> Bool {
//    let start1: Int = trip1.interval.start
//    let end1: Int = trip1.interval.end
//    let start2: Int = trip2.interval.start
//    let end2: Int = trip2.interval.end
//    
//    if start1 < start2 {
//        return true
//    }
//    else if start1 > start2 {
//        return false
//    }
//    else {
//        if end1 < end2 {
//            return true
//        }
//        else {
//            return false
//        }
//    }
//}

//let sortedTrips: [Trip] = trips.sort(tripSorter)

// Create graph and interval tree and add in all trips as vertices
var graph: Graph = Graph()
var intervalTree: IntervalTree?
var vertices: [Vertex] = [Vertex]()
for trip in trips {
    let nextVertex = graph.addVertex(trip)
    vertices.append(nextVertex)
    
    // Add to interval tree if the tree has been created, otherwise create it
    if intervalTree != nil {
        intervalTree?.checkAndAdd(nextVertex)
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
