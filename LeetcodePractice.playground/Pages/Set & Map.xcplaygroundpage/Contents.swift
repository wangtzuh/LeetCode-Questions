import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    let z: Int
    let xVal: Int
    let yVal: Int
    let zVal: Int
    let distance: Double
    
    init(x: Int, y: Int, z: Int, xVal: Int, yVal: Int, zVal: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.xVal = xVal
        self.yVal = yVal
        self.zVal = zVal
        self.distance = sqrt(Double(xVal * xVal + yVal * yVal + zVal * zVal))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == lhs.z
    }
    
}


/// Find K-th Closest Point To <0,0,0>
func findKthClosestToPoint(_ A: [Int], _ B: [Int], _ C: [Int], _ k: Int) -> [Int] {
    var minHeap = PriorityQueueEasy<Point> { $0.distance < $1.distance }
    var visited = Set<Point>()
    
    let start = Point(x: 0, y: 0, z: 0, xVal: A[0], yVal: B[0], zVal: C[0])
    minHeap.enqueue(start)
    visited.insert(start)
    
    for _ in 1..<k {
        // expand current;
        let curr = minHeap.dequeue()!
        
        if curr.x + 1 < A.count {
            let next = Point(x: curr.x + 1,
                             y: curr.y,
                             z: curr.z,
                             xVal: A[curr.x + 1],
                             yVal: B[curr.y],
                             zVal: C[curr.z])
            
            if !visited.contains(next) {
                minHeap.enqueue(next)
                visited.insert(next)
            }
        }
        
        if curr.y + 1 < B.count {
            let next = Point(x: curr.x,
                             y: curr.y + 1,
                             z: curr.z,
                             xVal: A[curr.x],
                             yVal: B[curr.y + 1],
                             zVal: C[curr.z])
            
            if !visited.contains(next) {
                minHeap.enqueue(next)
                visited.insert(next)
            }
        }
        
        if curr.z + 1 < C.count {
            let next = Point(x: curr.x,
                             y: curr.y,
                             z: curr.z,
                             xVal: A[curr.x],
                             yVal: B[curr.y],
                             zVal: C[curr.z + 1])
            
            if !visited.contains(next) {
                minHeap.enqueue(next)
                visited.insert(next)
            }
        }
    }
    
    let kthPoint = minHeap.dequeue()!
    return [kthPoint.x, kthPoint.y, kthPoint.z]
}

/*
 Given an unsorted array of integers, find the length of the longest consecutive elements sequence.

 For example,
 Given [95, 5, 3, 93, 2, 91, 92, 4]
 The longest consecutive elements sequence is [2, 3, 4, 5]. Return its length: 4.
 https://app.laicode.io/app/problem/447
 */
///  Longest consecutive sequence
func longestConsecutiveSequence(_ a: [Int]) -> Int {
    guard a.count > 1 else { return a.count }
    let set = Set(a)
    var result = 0
    for num in a {
        if !set.contains(num - 1) {
            var currNum = num
            var currLen = 1
            while set.contains(currNum + 1) {
                currNum += 1
                currLen += 1
            }
            result = max(result, currLen)
        }
    }
    return result
}
