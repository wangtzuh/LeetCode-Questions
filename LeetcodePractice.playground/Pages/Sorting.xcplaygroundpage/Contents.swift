import Foundation

var inputArray = [7,8,9,10,3,4,5,6,2,1]


/// Selection Sort
/// - Parameter input: Integer array needs to be sorted
/// - Returns: return sorted Integer array
func selectionSort(_ input: [Int]?) -> [Int]? {
    guard var input = input, input.count >= 2 else { return input }
    for i in 0..<input.count {
        var minIndex = i
        for j in i + 1..<input.count {
            if input[minIndex] > input[j] {
                minIndex = j
            }
        }
        let temp = input[i]
        input[i] = input[minIndex]
        input[minIndex] = temp
    }
    return input
}
selectionSort(inputArray)?.description


/// Inerstion sort
/// - Parameter input: Integer array needs to be sorted
/// - Returns: return sorted Integer array
func insertionSort(_ input: [Int]?) -> [Int]? {
    guard var input = input, input.count >= 2 else { return input }
    for i in 1..<input.count {
        var j = i - 1
        let key = input[i]
        while j >= 0 && input[j] > key {
            input[j + 1] = input[j]
            j = j - 1
        }
        input[j + 1] = key
    }
    return input
}
insertionSort(inputArray)?.description


/// Merge Sort
/// - Parameter input: Integer array needs to be sorted
/// - Returns: return sorted Integer array
func mergeSort(_ input: [Int]?) -> [Int]? {
    guard let input = input, input.count >= 2 else { return input }
    return mergeSortCore(input, left: 0, right: input.count - 1)
}


/// Merge sort core implmentation using recursion
func mergeSortCore(_ input: [Int], left: Int, right: Int) -> [Int] {
    if left == right { return [input[left]] }
    let mid = left + (right - left) / 2
    let leftPart = mergeSortCore(input, left: left, right: mid)
    let rightPart = mergeSortCore(input, left: mid + 1, right: right)
    return merge(left: leftPart, right: rightPart)
}


/// Helper method to merge two arrays into one sorted array in ascending order
/// - Parameters:
///   - left: first Integer array
///   - right: second Integer array
/// - Returns: sorted and merged array
func merge(left: [Int], right: [Int]) -> [Int] {
    var leftIndex = 0, rightIndex = 0
    var result = [Int]()
    while leftIndex < left.count && rightIndex < right.count {
        if left[leftIndex] <= right[rightIndex] {
            result.append(left[leftIndex])
            leftIndex += 1
        } else {
            result.append(right[rightIndex])
            rightIndex += 1
        }
    }
    if leftIndex < left.count {
        result = result + left[leftIndex..<left.count]
    }
    if rightIndex < right.count {
        result = result + right[rightIndex..<right.count]
    }
    return result
}

mergeSort(inputArray)?.description


/// Quick Sort
/// - Parameter input: Integer array needs to be sorted
/// - Returns: sorted Integer array
func quickSort(_ input: inout [Int]?) -> [Int]? {
    guard var input = input, input.count >= 2 else { return input }
    quickSortCore(&input, left: 0, right: input.count - 1)
    return input
}

private func quickSortCore(_ input: inout [Int], left: Int, right: Int) {
    if left >= right { return }
    let pivotIndex = partition(&input, left: left, right: right)
    quickSortCore(&input, left: left, right: pivotIndex - 1)
    quickSortCore(&input, left: pivotIndex + 1, right: right)
}


/// Partition the given Integer array with range from left bound to right bound with randomly selected pivot in between left bound and right bound.
/// - Parameters:
///   - input: Integer array
///   - left: Left bound
///   - right: Right bound
/// - Returns: The pivot index where all the elements on the left are smaller than pivot, and all the elements on the right are larger than the pivot.
private func partition(_ input: inout [Int], left: Int, right: Int) -> Int {
    let pivot = getRandomPivot(low: left, high: right)
    let pivotElement = input[pivot]
    swap(&input, left: pivot, right: right)
    var leftBound = left
    var rightBound = right - 1
    while leftBound <= rightBound {
        if input[leftBound] < pivotElement {
            leftBound += 1
        } else if input[rightBound] >= pivotElement {
            rightBound -= 1
        } else {
            swap(&input, left: leftBound, right: rightBound)
            leftBound += 1
            rightBound -= 1
        }
    }
    swap(&input, left: leftBound, right: right)
    return leftBound
}


/// Swap the elements at left to the elements at right for the input Integer array
private func swap(_ input: inout [Int], left: Int, right: Int) {
    let temp = input[left]
    input[left] = input[right]
    input[right] = temp
}


/// Function to get a Random Integer in between Lower bound and Upper bound
/// - Parameters:
///   - low: Min Integer
///   - high: Max Integer
/// - Returns: Random number in between low and high
private func getRandomPivot(low: Int, high: Int) -> Int {
    return Int.random(in: low...high)
}

var array: [Int]? = [6,7,8,9,10,1,2,3,4,5]
quickSort(&array)?.description


func moveZero(_ input: inout [Int]) {
    guard input.count >= 2 else { return }
    // maintain two pointers; left and right;
    //  [0...left) indicates all non-zeros; (right, end] indicates all zeros;
    //  [left, right] contains all the element needs to be re-arranged
    // init:
    //   left = 0; right = input.count - 1;
    // for each step:
    //   1. check input[left] != 0: left++
    //   2. check input[right] == 0; right--;
    //   3. else swap left right; left++ right--;
    // terminate: left >= right;
    var left = 0, right = input.count - 1
    while left <= right {
        if input[left] != 0 {
            left = left + 1
        } else if input[right] == 0 {
            right = right - 1
        } else {
            swap(&input, left: left, right: right)
            left = left + 1
            right = right - 1
        }
    }
}

var zeros = [0,0,1,1,0,1,0,3]
moveZero(&zeros)
print(zeros.description)



func rainbowSort(_ input: inout [Int]) -> [Int] {
    guard input.count >= 2 else { return input }
    var i = 0, j = 0, k = input.count - 1
    while j <= k {
        if input[j] == -1 {
            swap(&input, left: i, right: j)
            i += 1
            j += 1
        } else if input[j] == 0 {
            j += 1
        } else {
            swap(&input, left: j, right: k)
            k -= 1
        }
    }
    return input
}

var rainbow = [-1, 0, 0, 1, 1, -1, 0, 1]
rainbowSort(&rainbow).description


