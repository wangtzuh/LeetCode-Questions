import Foundation

// MARK: - SubSet Related, with concrete state options

/// All Subset
/// Given a set of characters represented by a String, return a list containing all subsets of the characters.
func getAllSubsets(_ set: String?) -> [String] {
    guard let set = set, set.count > 0 else { return [] }
    var result: [String] = []
    var curr: String = ""
    allSubsetsHelper(Array(set), 0, &curr, &result)
    return result
}

private func allSubsetsHelper(_ input: [Character], 
                              _ level: Int,
                              _ curr: inout String,
                              _ result: inout [String]) {
    if level == input.count {
        result.append(curr)
        return
    }
    // option 1: not pick
    allSubsetsHelper(input, level + 1, &curr, &result)
    // option 2: pick
    curr.append(input[level])
    allSubsetsHelper(input, level + 1, &curr, &result)
    curr.removeLast()
}
getAllSubsets("abc").description

/// All Subsets II
/// Given a set of characters represented by a String, return a list containing all subsets of the characters. Could be duplicate characters;
func getAllSubsetsWithDup(_ set: String?) -> [String] {
    guard let set = set, set.count > 0 else { return [] }
    var result = [String]()
    var curr = ""
    getAllSubsetsWithDupDfs(Array(set), 0, &curr, &result)
    return result
}

private func getAllSubsetsWithDupDfs(_ set: [Character],
                                     _ level: Int,
                                     _ curr: inout String,
                                     _ result: inout [String]) {
    if level == set.count {
        result.append(curr)
        return
    }
    // pick
    curr.append(set[level])
    getAllSubsetsWithDupDfs(set, level + 1, &curr, &result)
    curr.removeLast()
    // not pick; move level to the last occurance
    var level = level
    while level + 1 < set.count && set[level + 1] == set[level] {
        level += 1
    }
    getAllSubsetsWithDupDfs(set, level + 1, &curr, &result)
}
getAllSubsetsWithDup("abbbc")


/// All Subsets of Size K
/// Given a set of characters represented by a String, return a list containing all subsets of the characters whose size is K.
func getAllSubsets(_ set: String?, with size: Int) -> [String] {
    guard let set = set, set.count >= size else { return [] }
    var result: [String] = []
    var curr: String = ""
    getAllSubsetsWithSizeHelper(Array(set), size, 0, &curr, &result)
    return result
}

private func getAllSubsetsWithSizeHelper(_ set: [Character],
                                    _ size: Int,
                                    _ level: Int,
                                    _ curr: inout String,
                                    _ result: inout [String]) {
    if curr.count == size {
        result.append(curr)
        return
    }
    if level == set.count {
        return
    }
    getAllSubsetsWithSizeHelper(set, size, level + 1, &curr, &result)
    curr.append(set[level])
    getAllSubsetsWithSizeHelper(set, size, level + 1, &curr, &result)
    curr.removeLast()
}

getAllSubsets("abcd", with: 4).description

/// All Subsets II of Size K
/// Given a set of characters represented by a String, return a list containing all subsets of the characters whose size is K. "MAY" contains duplicate characters
func getAllSubSetsWithDup(_ set: String?, with size: Int) -> [String] {
    guard let set = set, set.count >= size else { return [] }
    var sortedSet = set.sorted()
    var curr = ""
    var result = [String]()
    getAllSubSetsWithDupDfs(sortedSet, size, 0, &curr, &result)
    return result
}

private func getAllSubSetsWithDupDfs(_ set: [Character],
                                     _ size: Int,
                                     _ level: Int,
                                     _ curr: inout String,
                                     _ result: inout [String]) {
    if curr.count == size {
        result.append(curr)
        return
    }
    if level >= set.count {
        return
    }
    curr.append(set[level])
    getAllSubSetsWithDupDfs(set, size, level + 1, &curr, &result)
    curr.removeLast()
    var level = level
    while level + 1 < set.count && set[level + 1] == set[level] {
        level += 1
    }
    getAllSubSetsWithDupDfs(set, size, level + 1, &curr, &result)
}

getAllSubSetsWithDup("abbcd", with: 4).description

/*
 Given a set of n integers, divide the set in two subsets of n/2 sizes each such that the difference of the sum of two subsets is as minimum as possible.

 Return the minimum difference(absolute value).
 */
/// Two Subsets With Min Difference
func twoSubSetMinDiff(_ array: [Int]) -> Int {
    var result = Int.max
    twoSubsetHelper(array, 0, (0, 0), (0, 0), &result)
    return result
}

private func twoSubsetHelper(_ array: [Int], 
                             _ index: Int,
                             _ sum: (Int, Int),
                             _ count: (Int, Int),
                             _ result: inout Int) {
    if index == array.count {
        if validCount(count) {
            result = min(result, abs(sum.0 - sum.1))
        }
        return
    }
    twoSubsetHelper(array, index + 1, (sum.0 + array[index], sum.1), (count.0 + 1, count.1), &result)
    twoSubsetHelper(array, index + 1, (sum.0, sum.1 + array[index]), (count.0, count.1 + 1), &result)
}

private func validCount(_ counts: (Int, Int)) -> Bool {
    return counts.0 == counts.1 || abs(counts.0 - counts.1) == 1
}

/*
 Given a string of numbers and operators, return all possible results from computing all the different possible ways to group numbers and operators in Ascending order. The valid operators are +, - and *.
 Input: "2-1-1".
 ((2-1)-1) = 0
 (2-(1-1)) = 2
 Output: [0, 2]
 
 Input: "2\*3-4\*5"
 (2*(3-(4*5))) = -34
 ((2*3)-(4*5)) = -14
 ((2*(3-4))*5) = -10
 (2*((3-4)*5)) = -10
 (((2*3)-4)*5) = 10
 Output: [-34, -14, -10, -10, 10]
 */
/// Different Ways to Add Parentheses
func diffWaysToCompute(_ input: String) -> [Int] {
    var memo = [String : [Int]]()
    return computeHelper(input, &memo)
}

func computeHelper(_ input: String, _ memo: inout [String : [Int]]) -> [Int] {
    if let result = memo[input] {
        return result
    }
    var result = [Int]()
    var array = Array(input)
    for i in 0..<array.count {
        if !array[i].isNumber { // case: * - +
            // get leftSub result for input[0..i]
            var leftRes = computeHelper(String(array[0..<i]), &memo)
            // get rightSub result from input[i+1...]
            var rightRes = computeHelper(String(array[(i + 1)...]), &memo)
            for left in leftRes {
                for right in rightRes {
                    if array[i] == "+" {
                        result.append(left + right)
                    }
                    if array[i] == "-" {
                        result.append(left - right)
                    }
                    if array[i] == "*" {
                        result.append(left * right)
                    }
                }
            }
        }
    }
    
    if result.isEmpty {
        result.append(Int(input)!)
    }
    result.sort()
    memo[input] = result
    return result
 }

diffWaysToCompute("2*3*2-1*2-2*3-1")


// MARK: - All Parenthese Related as each placement required additional conditions.
/*
 Given N pairs of parentheses “()”, return a list with all the valid permutations.

 Assumptions

 N > 0
 Examples

 N = 1, all valid permutations are ["()"]
 N = 3, all valid permutations are ["((()))", "(()())", "(())()", "()(())", "()()()"]
 https://app.laicode.io/app/problem/66
 */
///All Valid Permutations Of Parentheses I
func allValidParenthese(_ n: Int) -> [String] {
    var result = [String]()
    var temp: [Character] = Array(repeating: " ", count: n * 2)
    validParentheseHelper(&temp, 0, n, n, &result)
    return result
}

private func validParentheseHelper(_ temp: inout [Character], _ level: Int, _ left: Int, _ right: Int, _ result: inout [String]) {
    if level == temp.count {
        result.append(String(temp))
        return
    }
    if left > 0 {
        temp[level] = "("
        validParentheseHelper(&temp,
                              level + 1,
                              left - 1,
                              right,
                              &result)
    }
    if right > left {
        temp[level] = ")"
        validParentheseHelper(&temp,
                              level + 1,
                              left,
                              right - 1,
                              &result)
    }
}

allValidParenthese(3)

/*
 Get all valid permutations of l pairs of (), m pairs of <> and n pairs of {}.

 Assumptions

 l, m, n >= 0
 l + m + n > 0
 Examples

 l = 1, m = 1, n = 0, all the valid permutations are ["()<>", "(<>)", "<()>", "<>()"]
 https://app.laicode.io/app/problem/179?plan=3
 */

/// All Valid Permutations Of Parentheses II
func allValidParentheseII(_ l: Int, _ m: Int, _ n: Int) -> [String] {
    var remain = [l, l, m, m, n, n]
    var total = (l + m + n) * 2
    var stack = [String]()
    var result = [String]()
    var curr = ""
    allParentheseIIHelper(&remain, total, &curr, &stack, &result)
    return result
}

let PARNETHESE_ARRAY = ["(", ")", "<", ">", "{", "}"]

private func allParentheseIIHelper(_ remain: inout [Int], 
                                   _ total: Int,
                                   _ curr: inout String,
                                   _ stack: inout [String],
                                   _ result: inout [String]) {
    if curr.count == total {
        result.append(curr)
        return
    }
    for i in 0..<remain.count {
        if i % 2 == 0 { // for lefts
            if remain[i] > 0 {
                curr.append(PARNETHESE_ARRAY[i])
                remain[i] -= 1
                stack.append(PARNETHESE_ARRAY[i])
                allParentheseIIHelper(&remain, total, &curr, &stack, &result)
                curr.removeLast()
                remain[i] += 1
                stack.removeLast()
            }
        } else {
            if !stack.isEmpty && stack.last! == PARNETHESE_ARRAY[i - 1] {
                curr.append(PARNETHESE_ARRAY[i])
                remain[i] -= 1
                stack.removeLast()
                allParentheseIIHelper(&remain, total, &curr, &stack, &result)
                curr.removeLast()
                remain[i] += 1
                stack.append(PARNETHESE_ARRAY[i - 1])
            }
        }
    }
}
allValidParentheseII(1, 1, 1)

/*
 Get all valid permutations of l pairs of (), m pairs of <> and n pairs of {}, subject to the priority restriction: {} higher than <> higher than ().


 Assumptions
     l, m, n >= 0
     l + m + n >= 0


 Examples
     l = 1, m = 1, n = 0, all the valid permutations are ["()<>", "<()>", "<>()"].
     l = 2, m = 0, n = 1, all the valid permutations are [“()(){}”, “(){()}”, “(){}()”, “{()()}”, “{()}()”, “{}()()”].
 https://app.laicode.io/app/problem/642
 */
/// All Valid Permutations Of Parentheses III
func allValidParenthesesIII(_ l: Int, _ m: Int, _ n: Int) -> [String] {
    var remain = [l, l, m, m, n, n]
    var total = (l + m + n) * 2
    var stack = [Int]()
    var result = [String]()
    var curr = ""
    allParentheseIIIHelper(&remain, total, &curr, &stack, &result)
    return result
}

private func allParentheseIIIHelper(_ remain: inout [Int],
                                    _ total: Int,
                                    _ curr: inout String,
                                    _ stack: inout [Int],
                                    _ result: inout [String]) {
    if curr.count == total {
        result.append(curr)
        return
    }
    for i in 0..<remain.count {
        if i % 2 == 0 {
            if remain[i] > 0 && (stack.isEmpty || stack.last! > i) {
                curr.append(PARNETHESE_ARRAY[i])
                remain[i] -= 1
                stack.append(i)
                allParentheseIIIHelper(&remain, total, &curr, &stack, &result)
                curr.removeLast()
                remain[i] += 1
                stack.removeLast()
            }
        } else {
            if !stack.isEmpty && stack.last! == i - 1 {
                curr.append(PARNETHESE_ARRAY[i])
                remain[i] -= 1
                stack.removeLast()
                allParentheseIIIHelper(&remain, total, &curr, &stack, &result)
                curr.removeLast()
                remain[i] += 1
                stack.append(i - 1)
            }
        }
    }
}

allValidParenthesesIII(1,1,0)


///  Restore IP Addresses
///  Given a string containing only digits, restore it by retiring all possible valid IP address combinations.
/*
 Input:  ”25525511135”
 Output: [“255.255.11.135”, “255.255.111.35”]
 */

func restoreIpAddress(_ ip: String) -> [String] {
    guard ip.count >= 4 && ip.count <= 12 else {
        return []
    }
    var segments = [String]()
    var result = [String]()
    restoreIpHelper(Array(ip), 0, &segments, &result)
    return result
}

private func restoreIpHelper(_ ip: [Character],
                             _ start: Int,
                             _ segments: inout [String],
                             _ result: inout [String]) {
    // base case:
    if segments.count == 4 {
        if start == ip.count {
            result.append(segments.joined(separator: "."))
        }
        return
    }
    for len in 1...3 {
        if start + len > ip.count { break }
        let segment = String(ip[start..<start + len ])
        if isIpSegmentValid(segment) {
            segments.append(segment)
            restoreIpHelper(ip, start + len, &segments, &result)
            segments.removeLast()
        }
    }
}

private func isIpSegmentValid(_ segment: String) -> Bool {
    if segment.count > 1 && segment.first == "0" { return false }
    if let value = Int(segment), value >= 0 && value <= 255 {
        return true
    }
    return false
}

restoreIpAddress("0000")
restoreIpAddress("25525511135")

/// Flip Game to detemine whether we can win the game with first hand;
func flipGame(_ game: String?) -> Bool {
    guard let game = game, game.count > 1 else {
        return false
    }
    var set = Set<String>()
    var gameArray = Array(game)
    return flipGameHelper(&gameArray, &set)
}

private func flipGameHelper(_ game: inout [Character], _ set: inout Set<String>) -> Bool {
    let string = String(game)
    if set.contains(string) {
        return false
    }
    for i in 0..<game.count - 1{ // for each place position
        if game[i] == "+" && game[i + 1] == "+" {
            game[i] = "-"
            game[i + 1] = "-"
            if !flipGameHelper(&game, &set) {
                game[i] = "+"
                game[i + 1] = "+"
                return true
            }
            game[i] = "+"
            game[i + 1] = "+"
        }
    }
    set.insert(string)
    return false
}

flipGame("++++")
flipGame("++--+++--++")




// MARK: - Other Graph Search problems using DFS

/// Word Search
/// Given a 2D board and a word, find if the word exists in the grid.The word can be constructed from letters of sequentially adjacent cell, where "adjacent" cells are those horizontally or vertically neighboring. The same letter cell may not be used more than once.
/*
 Input: board = [
                    [“ABCE”],
                    [“SFCS”],
                    [“ADEE”]
                ]
 Output:
    Word = “ABCCED”   return true
    Word = “SEE”      return true
    Word = “ABCB”     return false
 */
func wordSearch(_ board: [[Character]], word: String) -> Bool {
    // use DFS to traverse from each coordinate from the board;
    // we check the character at r,c matched with the word[recursionLevel]; if so, move 4 directions to check
    // the next character; Also maintain a [[Bool]] for dedup
    // word.count levels; each level represents the character to matched;
    // at most 4 states
    var dedup = Array(repeating: Array(repeating: false, count: board[0].count), count: board.count)
    for i in 0..<board.count {
        for j in 0..<board[i].count {
            if wordSearchHelper(board, Array(word), 0, &dedup, row: i, col: j) {
                return true
            }
        }
    }
    return false
}

private func wordSearchHelper(_ board: [[Character]], 
                              _ word: [Character],
                              _ level: Int,
                              _ dedup: inout [[Bool]],
                              row: Int,
                              col: Int) -> Bool {
    // base case 1: matched
    if level >= word.count {
        return true
    }
    // base case 2: invalid case: index issue || visited || not matched
    if row < 0 || row >= board.count || col < 0 || col >= board[row].count || dedup[row][col] || board[row][col] != word[level] {
        return false
    }
    
    dedup[row][col] = true
    if wordSearchHelper(board, word, level + 1, &dedup, row: row + 1, col: col) ||
        wordSearchHelper(board, word, level + 1, &dedup, row: row - 1, col: col) ||
        wordSearchHelper(board, word, level + 1, &dedup, row: row, col: col + 1) ||
        wordSearchHelper(board, word, level + 1, &dedup, row: row, col: col - 1) {
        // only for follow up question to return all matched cases;
        dedup[row][col] = false
        return true
    }
    dedup[row][col] = false
    return false
}

let board = ["ABCE", "SFCS", "ADEE"].map({ Array($0) })
wordSearch(board, word: "ABCCED")
wordSearch(board, word: "ABCB")
let words = ["ABCCED", "ABCB", "SEE", "ADEE"]

func wordSearch(_ board: [[Character]], _ words: [String]) -> [String] {
    var result = [String]()
    var dedup = Array(repeating: Array(repeating: false, count: board[0].count), count: board.count)
    for word in words {
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if wordSearchHelper(board, Array(word), 0, &dedup, row: i, col: j) {
                    result.append(word)
                    continue
                }
            }
        }
        // Manually reset the dedup 2D array;
        // dedup = Array(repeating: Array(repeating: false, count: board[0].count), count: board.count)
    }
    return result
}
wordSearch(board, words)

func wordSearchTrie() -> [String] {
    return []
}
