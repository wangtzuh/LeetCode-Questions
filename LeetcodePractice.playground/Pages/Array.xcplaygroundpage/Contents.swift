import Foundation


// MARK: - Deduplication as manipulating pointers
/*
 Given a sorted integer array, remove duplicate elements. For each group of elements with the same value keep at most one of them.
 */
/// Array Deduplication I
func dedup(_ input: [Int]) -> [Int] {
    guard input.count >= 1 else { return input }
    var input = input
    var i = 1, curr = 1, prev = input[0]
    while i < input.count {
        if input[i] != prev {
            input[curr] = input[i]
            prev = input[i]
            curr += 1
        }
        i += 1
    }
    return Array(input[0..<curr])
}

var array = [1, 2, 2, 3, 3, 3]
dedup(array).description

/*
 Given a sorted integer array, remove duplicate elements. For each group of elements with the same value keep at most two of them.
 */
func dedupII(_ input: [Int]) -> [Int] {
    guard input.count > 2 else { return input }
    // i, curr;
    // for each iteration, check if array[i] == array[curr - 2];
    //      if true; advance i; else array[curr] == array[i]; curr += 1, i += 1
    var input = input
    var curr = 2
    for i in 2..<input.count {
        if array[i] != array[curr - 2] {
            array[curr] = array[i]
            curr += 1
        }
    }
    return Array(input[0..<curr])
}

/*
 Given a sorted integer array, remove duplicate elements. For each group of elements with the same value do not keep any of them.
 */
func dedupIII(_ input: [Int]) -> [Int] {
    guard input.count > 1 else { return input }
    var input = input
    var curr = 0, index = 0
    while index < input.count {
        let start = index
        while index < input.count && input[start] == input[index] {
            index += 1
        }
        if index - start <= 1 {
            input[curr] = input[start]
            curr += 1
        }
    }
    return Array(input[0..<curr])
}
dedupIII([1, 2, 2, 3, 3, 3]).description

/*
 Given an unsorted integer array, remove adjacent duplicate elements repeatedly, from left to right. For each group of elements with the same value do not keep any of them.
 */
func dedupIV(_ input: [Int]) -> [Int] {
    // maintain Stack:
    // for each iteration:
    //  case 1: stack.isEmpty || stack.last != input[i]
    //             stack.append input[i]; array[curr] = input[i]; cur++, i++
    //  case 2: stack.last == input[i]
    //           move i until array[i] != stack.last;
    //           stack.removeLast; curr -= 1
    guard input.count >= 1 else { return input }
    var input = input
    var index = 1, curr = 1
    var stack = [input[0]]
    while index < input.count {
        if stack.isEmpty || stack.last! != input[index] {
            stack.append(input[index])
            input[curr] = input[index]
            curr += 1
            index += 1
        } else {
            let top = stack.last!
            while index < input.count && input[index] == top {
                index += 1
            }
            stack.removeLast()
            curr -= 1
        }
    }
    return Array(input[0..<curr])
}
dedupIV([1,1,2,3,3,3,2,1,6])
/*
 Given an integer array(not guaranteed to be sorted), remove adjacent repeated elements. For each group of elements with the same value keep at most two of them.
 */
func dedupV(_ input: [Int]) -> [Int] {
    guard input.count > 2 else { return input }
    var input = input
    var curr = 2, index = 2
    while index < input.count {
        if input[curr - 1] == input[index] && input[curr - 2] == input[index] {
            let prev = input[curr - 1]
            while index < input.count && input[index] == prev {
                index += 1
            }
        } else {
            input[curr] = input[index]
            curr += 1
            index += 1
        }
    }
    return Array(input[0..<curr])
}
dedupV([4,4,4,1,2,3,3,3]).description

// MARK: - 2 Sum related
/*
 Determine if there exist two elements in a given array, the sum of which is the given target number.
 https://app.laicode.io/app/problem/180?plan=3
 */
/// 2 Sum
func twoSum(_ array: [Int], _ target: Int) -> Bool {
    guard array.count > 1 else { return false }
    var set: Set<Int> = []
    for num in array {
        if set.contains(target - num) {
            return true
        }
        set.insert(num)
    }
    return false
}
twoSum([2,2,3,5], 1)
twoSum([2,2,3,5], 5)
