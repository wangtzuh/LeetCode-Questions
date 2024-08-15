import Foundation

/// Classical binary search:
///     1. input array is sorted in acending order.
///     2. no duplicate elements in the input array.
///     3. input array might be null && target might not be found in the array;
///     Time: O(log n)
///     Space: O(1)

func binarySearch(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return nil }
    var left = 0
    var right = input.count - 1
    while left <= right {
        let mid = left + (right - left) / 2
        if input[mid] == target {
            return mid
        } else if input[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return nil
}

var array = [0,0,0,0,1,1,1,2,2,3,4,5,6,7,8]
var emptyArray = [Int]()

binarySearch(array, for: 5)
binarySearch(array, for: 2)
binarySearch(array, for: 7)
binarySearch(nil, for: 2)
binarySearch(array, for: 10)

/// Find the first occurance of the target for the input Integer array;
func firstOccur(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return nil }
    var left = 0, right = input.count - 1
    while left < right - 1 {
        let mid = left + (right - left) / 2;
        if input[mid] >= target {
            right = mid
        } else {
            left = mid
        }
    }
    
    if input[left] == target { return left }
    if input[right] == target {return right}
    return nil
}

/// Find the last occurance of the target for the Input Integer array:
func lastOccur(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return -1 }
    var left = 0, right = input.count - 1;
    while left < right - 1 {
        let mid = left + (right - left) / 2
        if input[mid] <= target {
            left = mid
        } else {
            right = mid - 1
        }
    }
    
    if input[right] == target { return right }
    if input[left] == target { return left }
    return nil
}

firstOccur(array, for: 0)
firstOccur(array, for: 1)
firstOccur(array, for: 2)
firstOccur(array, for: 5)
firstOccur(array, for: 7)
firstOccur(emptyArray, for: 3)

lastOccur(array, for: 0)
lastOccur(array, for: 1)
lastOccur(array, for: 2)
lastOccur(array, for: 5)
lastOccur(emptyArray, for: 1)
lastOccur(nil, for: 2)

/// Search for the element within 2D array:
func searchInMatrix(_ input: [[Int]]?, for target: Int) -> [Int]? {
    guard let input = input, input.count > 0, input[0].count > 0 else { return nil }
    var result = [-1, -1]
    let rowCount = input.count, colCount = input[0].count
    var left = 0, right = rowCount * colCount - 1
    
    while left <= right {
        let mid = left + (right - left) / 2
        let curr = input[mid / colCount][mid % colCount]
        if curr == target {
            result[0] = left / colCount
            result[1] = right % colCount
            return result
        } else if curr < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    
    return result
}

let matrix = [[0,1,2], [3,4,5], [6,7,8]]
searchInMatrix(matrix, for: 2)
searchInMatrix(matrix, for: 5)
searchInMatrix(matrix, for: 6)
searchInMatrix(matrix, for: 10)


struct TestStruct: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String {
        return "Debug: \(self.value)"
    }
    
    var description: String {
        return "\(self.value)"
    }
    let value: Int
}
var testMatrix = Array<Array<TestStruct>>(repeating: Array<TestStruct>(repeating: TestStruct(value: 3), count: 2), count: 3)
print(testMatrix.debugDescription)

/// Find the closest element to the target in the sorted array
func findClosest(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return nil }
    var left = 0, right = input.count - 1
    while left < right - 1 {
        let mid = left + (right - left) / 2
        if input[mid] == target {
            return mid
        } else if input[mid] < target {
            left = mid
        } else {
            right = mid
        }
    }
    return abs(input[left] - target) < abs(input[right] - target) ? left : right
}

findClosest(array, for: 9)
findClosest(array, for: 10)
findClosest(array, for: 4)

/// Find the closest K elements in the array with target
func findKClosest(in input: [Int]?, for target: Int, with times: Int) -> [Int]? {
    guard let input = input, input.count > 0, times > 0 else { return nil }
    guard var left = findClosest(input, for: target) else { return nil }
    var right = left + 1
    var result = [Int](repeating: 0, count: times)
    for i in 0..<times {
        if right >= input.count || left >= 0 && abs(input[left] - target) <= abs(input[right] - target) {
            result[i] = input[left]
            left = left - 1
        } else {
            result[i] = input[right]
            right = right + 1
        }
    }
    return result
}

findKClosest(in: array, for: 3, with: 3)
findKClosest(in: array, for: 3, with: 4)

func searchInShifted(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return nil }
    var left = 0, right = input.count - 1
    while left < right - 1 {
        let mid = left + (right - left) / 2
        if input[mid] == target { return mid }
        if input[mid] > input[left] && within(target, input[left], input[mid]) ||
            input[mid] < input[right] && !within(target, input[mid], input[right]) {
            right = mid - 1;
        } else {
            left = mid + 1
        }
    }
    if input[left] == target { return left }
    if input[right] == target { return right }
    return -1
    
    func within(_ target: Int, _ leftBound: Int, _ rightBound: Int) -> Bool {
        return target >= leftBound && target <= rightBound
    }
}

let shiftedArray = [3,4,5,1,2]
let shiftedArray2 = [1,2,3,4,5]
searchInShifted(shiftedArray, for: 4)
searchInShifted(shiftedArray, for: 3)
searchInShifted(shiftedArray, for: 1)
searchInShifted(shiftedArray2, for: 4)
searchInShifted(shiftedArray2, for: 1)
searchInShifted(shiftedArray, for: 6)


func searchInDuplShifted(_ input: [Int]?, for target: Int) -> Int? {
    guard let input = input, input.count > 0 else { return nil }
    var left = 0, right = input.count - 1
    while left < right - 1 {
        var mid = left + (right - left) / 2
        if input[left] == target { return left }
        // We need to return the smallest index of the occurance
        if input[mid] == target {
            right = mid
            continue
        }
        if input[mid] > input[left] && within(target, input[left], input[mid]) ||
            input[mid] < input[right] && !within(target, input[mid], input[right]) {
            right = mid;
        } else if input[mid] < input[right] && within(target, input[mid], input[right]) ||
                    input[mid] > input[left] && !within(target, input[left], input[mid]) {
            left = mid + 1
        } else {
            left = left + 1
            right = right - 1
        }
    }
    if input[left] == target { return left }
    if input[right] == target { return right }
    return -1
    
    func within(_ target: Int, _ leftBound: Int, _ rightBound: Int) -> Bool {
        return target >= leftBound && target <= rightBound
    }
}

let shiftedDupl = [1,1,1,1,1,3]
let shiftedDupl2 = [3,3,3,3,1,3]
searchInDuplShifted(shiftedDupl, for: 3)
searchInDuplShifted(shiftedDupl, for: 1)
searchInDuplShifted(shiftedDupl2, for: 1)

func findShiftedPosition(_ input: [Int]?) -> Int? {
    guard let input = input else { return nil }
    var left = 0, right = input.count - 1
    while (left < right - 1) {
        let mid = left + (right - left) - 1
        // no shifted array: a[left] < a[mid] < a[right]
        if input[mid] > input[left] && input[mid] < input[right] {
            return left
        } else if input[mid] < input[right] {   // right is acending; no shifted
            right = mid
        } else { // left is acending;
            left = mid
        }
    }
    if (input[left] < input[right]) {
        return left
    } else {
        return right
    }
}

//let shiftedArray = [3,4,5,1,2]
//let shiftedArray2 = [1,2,3,4,5]
let shiftedArray3 = [7,9,1,2,3,4,5]
findShiftedPosition(shiftedArray)
findShiftedPosition(shiftedArray2)
findShiftedPosition(shiftedArray3)

func searchInSortedMatrix(_ matrix: [[Int]]?, for target: Int) -> (row: Int, col: Int)? {
    guard let matrix = matrix, matrix.count > 0, matrix[0].count > 0 else { return nil }
    var currRow = 0, currCol = matrix[0].count
    while currRow < matrix.count && currCol >= 0 {
        if matrix[currRow][currCol] == target {
            return (row: currRow, col: currCol)
        } else if matrix[currRow][currCol] < target {
            currRow += 1
        } else {
            currCol -= 1
        }
    }
    return nil
}

func findSqrt(for target: Int) -> Int {
    if target == 0 || target == 1 { return target }
    var left: Double = 2.0, right = Double(target - 1)
    while left < right - 1 {
        let mid = left + (right - left) / 2
        if mid * mid > Double(target) {
            right = mid - 1
        } else {
            left = mid
        }
    }
    if (right * right <= Double(target)) {
        return Int(right)
    } else {
        return Int(left)
    }
}

findSqrt(for: 1234567)
findSqrt(for: 9)
findSqrt(for: 255)

let image = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]

func findRect(_ image: [[Int]], x: Int, y: Int) -> Int {
    var top = x, bottom = x, left = y, right = y
    for i in 0..<image.count {
        for j in 0..<image[i].count {
            if image[i][j] == 1 {
                top = min(top, i)
                bottom = max(bottom, i)
                left = min(left, j)
                right = max(right, j)
            }
        }
    }
    return (right - left + 1) * (bottom - top + 1)
}

findRect(image, x: 6, y: 29)


