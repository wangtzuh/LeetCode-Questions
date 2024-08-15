import Foundation


/*
 Given an array A of non-negative integers, you are initially positioned at an arbitrary index of the array. A[i] means the maximum jump distance from that position (you can either jump left or jump right). Determine the minimum jumps you need to reach the right end of the array. Return -1 if you can not reach the right end of the array.

 Assumptions

 The given array is not null and has length of at least 1.
 Examples

 {1, 3, 1, 2, 2}, if the initial position is 2, the minimum jumps needed is 2 (jump to index 1 then to the right end of array)
 {3, 3, 1, 0, 0}, if the initial position is 2, the minimum jumps needed is 2 (jump to index 1 then to the right end of array)
 {4, 0, 1, 0, 0}, if the initial position is 2, you are not able to reach the right end of array, return -1 in this case.
 https://app.laicode.io/app/problem/91
 */
/// Array Hopper IV
func minJump(_ a: [Int], _ index: Int) -> Int {
    // BFS to explore all possible moves
    // Queue<(Index, Jumps)>
    // Expand:
    //  queue.removeFirst()
    //  if currIndex == a.count - 1; return jumps;
    // Generate:
    //   right: for each valid currIndex + jump; queue.offer(nextIndex, jumps + 1)
    //   left: for each valid currIndex - jump; queue.offer(nextIndex, jumps + 1)
    //
    guard a.count > 0 else { return -1 }
    if a.count == 1 { return 1 }
    var queue: [(index: Int, jumps: Int)] = [(index, 0)]
    var dedup = Array(repeating: false, count: a.count)
    dedup[index] = true
    while !queue.isEmpty {
        let currSize = queue.count
        for i in 0..<currSize {
            let curr = queue.removeFirst()
            if curr.index == a.count - 1 {
                return curr.jumps
            }
            guard a[curr.index] >= 1 else { continue }
            // explore right
            for j in 1...a[curr.index] {
                let nextIndex = curr.index + j
                if nextIndex < a.count && !dedup[nextIndex] {
                    queue.append((nextIndex, curr.jumps + 1))
                    dedup[nextIndex] = true
                }
            }
            // explore left
            for j in 1...a[curr.index] {
                let nextIndex = curr.index - j
                if nextIndex >= 0 && !dedup[nextIndex]{
                    queue.append((nextIndex, curr.jumps + 1))
                    dedup[nextIndex] = true
                }
            }
        }
    }
    return -1
}
minJump([6,0,2,0,1,0,4], 4)
minJump([1,3,1,2,2], 2)
