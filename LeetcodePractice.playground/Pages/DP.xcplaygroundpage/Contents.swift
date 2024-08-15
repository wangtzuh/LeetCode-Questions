import Foundation

// MARK: - 1D Array
/// Largest SubArray Sum
/// Given an unsorted integer array, find the subarray that has the greatest sum. Return the sum.
/*
 Assumptions

 The given array is not null and has length of at least 1.
 Examples

 {2, -1, 4, -2, 1}, the largest subarray sum is 2 + (-1) + 4 = 5
 {-2, -1, -3}, the largest subarray sum is -1
 */
func largestSubarraySum(_ input: [Int]) -> Int {
    guard input.count >= 1 else {
        return 0
    }
    var preMax = input[0]
    var result = preMax
    for i in 1..<input.count {
        preMax = max(input[i], input[i] + preMax)
        result = max(result, preMax)
    }
    return result
}
largestSubarraySum([-2,1,-3,4,-1,2,1,-5,4])

/// FollowUp: Longest Subarray Sum
func largestSubarraySumWithIndex(_ input: [Int]) -> (sum: Int, left: Int, right: Int) {
    var result = (input[0], 0, 0)
    var prevLeft = 0
    var prevSum = input[0]
    for i in 1..<input.count {
        if prevSum >= 0 {
            prevSum += input[i]
        } else {
            prevSum = input[i]
            prevLeft = i
        }
        if prevSum > result.0 {
            result = (prevSum, prevLeft, i)
        }
    }
    return result
}
largestSubarraySumWithIndex([-2,-1, -4])

/// Largest SubArray Product
/// Given an unsorted array of doubles, find the subarray that has the greatest product. Return the product.
/*
 Assumptions
 
 The given array is not null and has length of at least 1.
 Examples
 
 {2.0, -0.1, 4, -2, -1.5}, the largest subarray product is 4 * (-2) * (-1.5) = 12
*/

// DP[i] = max/min (input[i], input[i - 1] * input[i]);
// Need to swap between preMax and preMin to ensure after calculation,
// preMax is always larger than preMin for negative numbers;
func largestProduct(_ input: [Double]) -> Double {
    guard input.count > 0 else { return 0.0 }
    var result = input[0]
    var preMax = result
    var preMin = result
    
    for i in 1..<input.count {
        if input[i] < 0 {
            let temp = preMax
            preMax = preMin
            preMin = temp
        }
        preMax = max(input[i], preMax * input[i])
        preMin = min(input[i], preMin * input[i])
        result = max(result, preMax)
    }
    return result
}



/* Given a string with only character 'a' and 'b', replace some of the characters such that the string becomes in the forms of all the 'b's are on the right side of all the 'a's.

 Determine what is the minimum number of replacements needed.
 Examples:

 "abaab", the minimum number of replacements needed is 1 (replace the first 'b' with 'a' so that the string becomes "aaaab").
 */
/// Replacements Of A and B
func minReplacement(_ input: String) -> Int {
    // two dps:
    //  aDp[i] = min replacement to replace [0..<1] to a from left to right
    //  bDp[j]= min replacement to replace [j..<endIndex] to b from right to left;
    //  result = max(aDp[endIndex-1], bDp[0]) --> convert all As, or convert all Bs.
    //  result = aDp[i] + bDp[i + 1] as convert As till i and convert Bs after i + 1...end
    var aDp = Array(repeating: 0, count: input.count)
    for (i, char) in input.enumerated() {
        if i == 0 {
            aDp[i] = char == "a" ? 0:1
        } else if char == "b"{
            aDp[i] = aDp[i - 1] + 1
        } else {
            aDp[i] = aDp[i - 1]
        }
    }
    
    var bDp = Array(repeating: 0, count: input.count)
    for (i, char) in input.enumerated().reversed() {
        if i == input.count - 1 {
            bDp[i] = char == "b" ? 0:1
        } else if char == "a"{
            bDp[i] = bDp[i + 1] + 1
        } else {
            bDp[i] = bDp[i + 1]
        }
    }
    
    var result = max(bDp[0], aDp[input.count - 1])
    for i in 0..<input.count - 1{
        result = max(result, aDp[i] + bDp[i + 1])
    }
    return result
}

minReplacement("abaababa")

/*
 A message containing letters from A-Z is being encoded to numbers using the following ways:
          ‘A’ = 1
          ‘B’ = 2
          …
          ‘Z’ = 26
 Given an encoded message containing digits, determine the total number of ways to decode it.
 Input:    “212”
 It can be either decoded as 2,1,2("BAB") or 2,12("BL") or 21,2("UB"), return 3.
 */
/// Decode Ways
func numOfDecodeWays(input: String) -> Int {
    // DP[i] = num of ways to decode the substring from 0..<i
    // Induction Rule:
    //  1. check current: i-1, is a single digit from 1...9;
    //  2. check current: i-1 + prev: i-2 to form 10...26
    // DP[i] += DP[i - 1] only if input[i - 1] is a valid signle digit; 1...9
    // DP[i] += DP[i - 2] only if input[i-2..<i] is a valid double digit num; 10...26
    // DP[0] = 0, DP[1] = input[0] > 0 ? 1:0
    guard input.count >= 2 else { return 1}
    var dp = Array(repeating: 0, count: input.count + 1)
    var array = Array(input)
    dp[0] = 1
    dp[1] = Int(String(array[0..<1]))! != 0 ? 1:0
    for i in 2..<array.count + 1 {
        let singleDigit = Int(String(array[i - 1]))!
        let doubleDigit = Int(String(array[i-2..<i]))!
        if singleDigit >= 1 && singleDigit <= 9 {
            dp[i] += dp[i - 1]
        }
        if doubleDigit >= 10 && doubleDigit <= 26 {
            dp[i] += dp[i - 2]
        }
    }
    return dp[input.count]
}

numOfDecodeWays(input: "62122323")

/*
 Given a string containing just the characters '(' and ')', find the length of the longest valid (well-formed) parentheses substring.
 Example:
 ")()())", where the longest valid parentheses substring is "()()", which has length = 4.
 */
/// Longest Valid Parentheses
func longestValidParentheses(_ s: String) -> Int {
    // Dp[i] -> longest valid paren ended at i index;
    // Induction Rule: if curr = )
    //  1. check prev element i - 1 == "("  --> dp[i] = dp[i - 2] + 2
    //  2. check prev concecutive paren; i - dp[i - 1] - 1 is "("
    //        if so, connect prev result; += dp[i - 1]
    //               connect the result from the init ( 's result
    guard s.count >= 2 else { return 0 }
    var dp = Array(repeating: 0, count: s.count)
    var array = Array(s)
    var maxLen = 0
    for i in 1..<array.count {
        let char = array[i]
        guard char == ")" else { continue }
        if (array[i - 1] == "(") {
            dp[i] = i >= 2 ? dp[i - 2] + 2 : 2
        } else if i - dp[i - 1] - 1 >= 0 && array[i - dp[i - 1] - 1] == "(" {
            dp[i] += dp[i - 1]
            dp[i] += i - dp[i - 1] >= 2 ? dp[i - dp[i - 1] - 2] + 2 : 2
        }
        print("i = \(i), dp[i] = \(dp[i])")
        maxLen = max(maxLen, dp[i])
    }
    return maxLen
}
longestValidParentheses("((())()))")
longestValidParentheses("))((())()))")


/*
 Given an array A of non-negative integers, you are initially positioned at index 0 of the array. A[i] means the maximum jump distance from that position (you can only jump towards the end of the array). Determine if you are able to reach the last index.

 Assumptions

 The given array is not null and has length of at least 1.
 Examples

 {1, 3, 2, 0, 3}, we are able to reach the end of array(jump to index 1 then reach the end of the array)
 {2, 1, 1, 0, 2}, we are not able to reach the end of array
 */
/// Array Hopper I
func canJump(_ a: [Int]) -> Bool {
    // dp[i] = can jump to end (a.count) when stood at i
    // base case: dp[a.count] = true
    // induction rule:
    //  dp[i] = true if
    //      1. a[i] + i >= array.length - 1
    //      2. for j in a[i]...1; if dp[i + j] = true
    if a.count == 1 {
        return true
    }
    var dp = Array(repeating: false, count: a.count + 1)
    dp[a.count] = true
    for i in (0..<a.count).reversed() {
        if a[i] + i >= a.count - 1{    // direct jump
            dp[i] = true
        } else {                        // check prev results
            for j in (1...a[i]).reversed() {
                if i + j < a.count && dp[i + j] == true {
                    dp[i] = true
                }
            }
        }
    }
    return dp[0]
}
canJump([1,1,1,1,1,1])

func minJump(_ a: [Int]) -> Int {
    guard a.count > 0 else { return -1 }
    var dp = Array(repeating: -1, count: a.count + 1)
    dp[a.count] = 0
    for i in (0..<a.count).reversed() {
        if a[i] + i >= a.count {
            dp[i] = 1
        } else {
            guard a[i] >= 1 else { continue }
            for j in 1...a[i] {
                if dp[i + j] != -1 {
                    if dp[i] == -1 {
                        dp[i] = dp[i + j] + 1
                    } else {
                        dp[i] = min(dp[i + j] + 1, dp[i])
                    }
                }
            }
        }
    }
    return dp[0]
}
minJump([4,2,1,3,2,1,0,4])

/*
 Given an array A[0]...A[n-1] of integers, find out the length of the longest ascending subsequence.

 Assumptions

 A is not null
 Examples
 Input: A = {5, 2, 6, 3, 4, 7, 5}
 Output: 4
 Because [2, 3, 4, 5] is the longest ascending subsequence.
 https://app.laicode.io/app/problem/1
 */
/// Longest Ascending Subsequence
func longestAcendingSubsequence(_ a: [Int]) -> Int {
    guard a.count >= 1 else { return a.count }
    var dp = Array(repeating: 1, count: a.count)
    var result = 1
    for i in 1..<a.count {
        for j in 0..<i {
            if a[i] > a[j] {
                dp[i] = max(dp[j] + 1, dp[i])
            }
            result = max(dp[i], result)
        }
    }
    return result
}

/// Follow up for pre question; Return the acending subsequence instead
func longestAcendingSubsequenceReturnAll(_ a: [Int]) -> [Int] {
    guard a.count >= 1 else { return a }
    var dp = Array(repeating: 1, count: a.count)
    var prev = Array(repeating: 0, count: a.count)
    prev[0] = -1
    var maxLen = 1
    var lastIndex = 1
    for i in 1..<a.count {
        prev[i] = i
        for j in 0..<i {
            if a[i] > a[j] {
                if (dp[j] + 1 > dp[i]) {
                    dp[i] = dp[j] + 1
                    prev[i] = j
                }
            }
            if dp[i] > maxLen {
                maxLen = dp[i]
                lastIndex = i
            }
        }
    }
    var result = Array(repeating: 0, count: maxLen)
    for i in (0..<maxLen).reversed() {
        guard lastIndex >= 0 else { break }
        result[i] = a[lastIndex]
        lastIndex = prev[lastIndex]
    }
    return result
}
let array = [2,4,8,14,14,12,7,14,28,24,9,30,28,29,26,3,17,18,5,29,18,8,30,32,13,29,6]
print(longestAcendingSubsequence(array))
print(longestAcendingSubsequenceReturnAll(array))

// MARK: - Cutting Problems: subproblems are similar but not identical
/*
 Given a rope with positive integer-length n, how to cut the rope into m integer-length parts with length p[0], p[1], ...,p[m-1], in order to get the maximal product of p[0]*p[1]* ... *p[m-1]? m is determined by you and must be greater than 0 (at least one cut must be made). Return the max product you can have.

 Assumptions

 n >= 2
 Examples

 n = 12, the max product is 3 * 3 * 3 * 3 = 81(cut the rope into 4 pieces with length of each is 3).
 */
/// Max Product Of Cutting Rope
func maxProductOfCuttingWood(_ len: Int) -> Int {
    guard len > 1 else { return len }
    var dp = Array(repeating: 0, count: len + 1)
    dp[1] = 1
    for i in 2...len {
        // determine first cut position
        for j in 1..<i {
            // leftPart remain the cutted portion; right part, we check if we need further cuts;
            dp[i] = max(dp[i], (i - j) * max(j, dp[j]))
        }
    }
    return dp[len]
}
maxProductOfCuttingWood(12)


/*
 Given a word and a dictionary, determine if it can be composed by concatenating words from the given dictionary.

 Assumptions

 The given word is not null and is not empty
 The given dictionary is not null and is not empty and all the words in the dictionary are not null or empty
 Examples

 Dictionary: {“bob”, “cat”, “rob”}

 Word: “robob” return false
 Word: “robcatbob” return true since it can be composed by "rob", "cat", "bob"
 https://app.laicode.io/app/problem/99?plan=3
 */
/// Dictionary Word I
func canBreakInDictWords(_ input: String, _ dict: Set<String>) -> Bool {
    // dp[i] states: [0...i) can be cut into words in set
    let a = Array(input)
    var dp = Array(repeating: false, count: input.count + 1)
    dp[0] = true
    for i in 1...input.count {
        if dict.contains(String(a[0..<i])) {
            dp[i] = true
            continue
        }
        for j in 1..<i {
            if dp[j] && dict.contains(String(a[j..<i])) {
                dp[i] = true
                break
            }
        }
    }
    return dp[input.count]
}
canBreakInDictWords("robcatbob", ["rob", "cat", "d", "bob"])

// MARK: - 2D Dp
/*
 Given two strings of alphanumeric characters, determine the minimum number of Replace, Delete, and Insert operations needed to transform one string into the other.

 Assumptions

 Both strings are not null
 Examples

 string one: “sigh”, string two : “asith”

 the edit distance between one and two is 2 (one insert “a” at front then replace “g” with “t”).
 */
/// Edit Distaance
func editDistanceDp(_ one: String, _ two: String) -> Int {
    // base on the recursion method
    // dp[i][j] = min operations to convert [0...i) from one to [0...j) from two
    var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: two.count + 1), 
                            count: one.count + 1)
    print(dp.description)
    for i in 1...one.count {
        dp[i][0] = i
    }
    for j in 1...two.count {
        dp[0][j] = j
    }
    for i in 1...one.count {
        for j in 1...two.count {
            if one[i] == two[j] {
                dp[i][j] = dp[i - 1][j - 1]
            } else {
                dp[i][j] = min(dp[i - 1][j - 1], dp[i][j - 1], dp[i - 1][j]) + 1
            }
        }
    }
    print(dp.description)
    return dp[one.count][two.count]
}

private func editDistanceRecursion(_ one: String, _ two: String) -> Int {
    // base case:
    //  if one isEmpty || two isEmpty; return rest length
    // recursive rule:
    //  if first char are the same; advance next char
    //  replace = i + 1, j + 1
    //  delete = i + 1, j
    //  insert = i, j + 1
    if one.isEmpty { return two.count }
    if two.isEmpty { return one.count }
    if let first = one.first, let second = two.first, first == second {
        return editDistanceRecursion(one.substring(from: 1), two.substring(from: 1))
    }
    let replace = 1 + editDistanceRecursion(one.substring(from: 1), two.substring(from: 1))
    let insert = 1 + editDistanceRecursion(one, two.substring(from: 1))
    let delete = 1 + editDistanceRecursion(one.substring(from: 1), two)
    return min(delete, replace, insert)
}
editDistanceRecursion("sigh", "asith")
editDistanceDp("sigh", "asith")

/*
 Determine the largest square of 1s in a binary matrix (a binary matrix only contains 0 and 1), return the length of the largest square.
 Assumptions:
    The given matrix is not null and guaranteed to be of size N * N, N >= 0
 Examples:
 { {0, 0, 0, 0},
   {1, 1, 1, 1},
   {0, 1, 1, 1},
   {1, 0, 1, 1} }
 the largest square of 1s has length of 2
 */
/// Largest Square Of 1s
func largestSquareOf1(_ matrix: [[Int]]) -> Int {
    guard matrix.count > 0 && matrix[0].count > 0 else { return 0 }
    var dp = Array(repeating: Array(repeating: 0, count: matrix[0].count), count: matrix.count)
    var result = 0
    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            if i == 0 || j == 0 {
                dp[i][j] = matrix[i][j] == 1 ? 1:0
            } else if matrix[i][j] == 0 {
                dp[i][j] = 0
            } else {
                dp[i][j] = min(dp[i - 1][j - 1], dp[i][j - 1], dp[i - 1][j]) + 1
            }
            result = max(result, dp[i][j])
        }
    }
    return result
}

/*
Given a matrix that contains only 1s and 0s, find the largest cross which contains only 1s, with the same arm lengths and the four arms joining at the central point.

Return the arm length of the largest cross.

Assumptions

The given matrix is not null, has size of N * M, N >= 0 and M >= 0.
Examples

{ {0, 0, 0, 0},

  {1, 1, 1, 1},

  {0, 1, 1, 1},

  {1, 0, 1, 1} }

the largest cross of 1s has arm length 2.
 https://app.laicode.io/app/problem/104?plan=3
*/
 
/// Longest Cross Of 1s
func largestCrossOf1(_ matrix: [[Int]]) -> Int {
    // Find dp of consecutive 1s for four directions, as
    // the possible edge length of 4 directions;
    let r = matrix.count, c = matrix[0].count
    var leftRight = Array(repeating: Array(repeating: 0, count: c), count: r)
    var rightLeft = Array(repeating: Array(repeating: 0, count: c), count: r)
    var topBottom = Array(repeating: Array(repeating: 0, count: c), count: r)
    var bottomTop = Array(repeating: Array(repeating: 0, count: c), count: r)
    // Left -> Right
    for i in 0..<r {
        for j in 0..<c {
            if matrix[i][j] == 1 {
                leftRight[i][j] = j == 0 ? 1 : leftRight[i][j - 1] + 1
                topBottom[i][j] = i == 0 ? 1 : topBottom[i - 1][j] + 1
            }
        }
    }
    // Right -> Left
    for i in (0..<r).reversed() {
        for j in (0..<c).reversed() {
            if matrix[i][j] == 1 {
                rightLeft[i][j] = j == c - 1 ? 1 : leftRight[i][j - 1] + 1
                bottomTop[i][j] = i == r - 1 ? 1: bottomTop[i + 1][j] + 1
            }
        }
    }
    var result = 0
    for i in 0..<r{
        for j in 0..<c {
            result = max(result,
                         min(leftRight[i][j],
                             topBottom[i][j],
                             rightLeft[i][j],
                             bottomTop[i][j]))
        }
    }
    return result
}

/*
 Determine the largest square surrounded by 1s in a binary matrix (a binary matrix only contains 0 and 1), return the length of the largest square.


 Assumptions
 The given matrix is guaranteed to be of size M * N, where M, N >= 0


 Examples
 {{1, 0, 1, 1, 1},
  {1, 1, 1, 1, 1},
  {1, 1, 0, 1, 0},
  {1, 1, 1, 1, 1},
  {1, 1, 1, 0, 0}}


 The largest square surrounded by 1s has length of 3.
 */
/// Largest Rectangle Of 1s
func largestRectangleOf1(_ matrix: [[Int]]) -> Int {
    // run consecutive 1s dp for two direction, leftRight, topBottom;
    // therefore, for each (i,j), we can have possible top edge len as
    // topBottom[i][j], and the possble leftEdge by leftRight[i][j]
    // then, for each width from j - leftEdge[i][j], we can find the
    //  curr minHeight by compare with prev topBottom value; can get the
    // current rectangle area
    let r = matrix.count, c = matrix[0].count
    var leftRight = Array(repeating: Array(repeating: 0, count: c), count: r)
    var topBottom = Array(repeating: Array(repeating: 0, count: c), count: r)
    for i in 0..<r {
        for j in 0..<c {
            if matrix[i][j] == 1 {
                leftRight[i][j] = j == 0 ? 1 : leftRight[i][j - 1] + 1
                topBottom[i][j] = i == 0 ? 1 : topBottom[i - 1][j] + 1
            }
        }
    }
    var result = 0
    for i in 0..<r {
        for j in 0..<c {
            var minHeight = topBottom[i][j]
            for k in stride(from: j, through: j - leftRight[i][j] + 1, by: -1) {
                minHeight = min(minHeight, topBottom[i][j])
                var width = j - k + 1
                result = max(result, width * minHeight)
            }
        }
    }
    return result
}


func largestSquareSurrondedBy1(_ matrix: [[Int]]) -> Int {
    let r = matrix.count, c = matrix[0].count
    var rightLeft = Array(repeating: Array(repeating: 0, count: c), count: r)
    var bottomTop = Array(repeating: Array(repeating: 0, count: c), count: r)
    for i in (0..<r).reversed() {
        for j in (0..<c).reversed() {
            if matrix[i][j] == 1 {
                rightLeft[i][j] = j == c - 1 ? 1 : rightLeft[i][j + 1] + 1
                bottomTop[i][j] = i == r - 1 ? 1 : bottomTop[i + 1][j] + 1
            }
        }
    }
    var result = 0
    for i in 0..<r {
        for j in 0..<c {
            // potential max edge length for the square with top-left vertex at (i,j)
            var edgeLen = min(rightLeft[i][j], bottomTop[i][j])
            // check if we can form a square with the target edge len
            while edgeLen > 0{
                if bottomTop[i][j + edgeLen - 1] >= edgeLen
                    && rightLeft[i + edgeLen - 1][j] >= edgeLen {
                    result = max(result, edgeLen)
                    break
                }
                edgeLen -= 1
            }
        }
    }
    return result
}

let matrix = [[1,1,1,1,1,1,0,1,1,1,0,0,1,1,1,0,0,1],[0,0,0,1,0,1,1,0,1,1,1,1,0,1,0,1,0,1],[1,1,1,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1],[1,1,1,0,1,0,0,1,0,0,1,1,1,1,1,1,1,1],[1,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,1,1,1,0,1,1,1,1,1,1,0,1],[0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1],[1,1,1,1,1,1,0,1,0,1,1,1,0,0,0,0,0,1],[0,1,0,0,1,1,0,0,0,1,0,0,0,0,0,1,1,1],[0,1,1,1,0,1,1,1,0,1,1,1,1,1,0,0,0,1],[1,1,0,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1]]

largestSquareSurrondedBy1(matrix)
largestRectangleOf1(matrix)
