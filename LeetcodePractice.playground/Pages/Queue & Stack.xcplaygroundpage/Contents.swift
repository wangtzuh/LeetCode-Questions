import Foundation
/// Count atoms
/*
 Given a chemical formula (given as a string), return the count of each atom.

 An atomic element always starts with an uppercase character, then zero or more lowercase letters, representing the name.

 1 or more digits representing the count of that element may follow if the count is greater than 1. If the count is 1, no digits will follow. For example, H2O and H2O2 are possible, but H1O2 is impossible.

 Two formulas concatenated together produce another formula. For example, H2O2He3Mg4 is also a formula.

 A formula placed in parentheses, and a count (optionally added) is also a formula. For example, (H2O2) and (H2O2)3 are formulas.

 Given a formula, output the count of all elements as a string in the following form: the first name (in sorted order), followed by its count (if that count is more than 1), followed by the second name (in sorted order), followed by its count (if that count is more than 1), and so on.
 
 Input:
 formula = "K4(ON(SO3)2)2"
 Output: "K4N2O14S4"
 Explanation:
 The count of elements are {'K': 4, 'N': 2, 'O': 14, 'S': 4}.
 */
func countAtoms(_ input: String) -> String {
    // Stack<Map<String, Integer>> prevStates;
    // Map<String, Integer> currState;
    // case 1: '(': start new state, and save current to preStates;
    // case 2: ')': finish currState, merge currState to Top of preStates;
    // case 3: same state processing
    var prevStates: [[String: Int]] = []
    var currState: [String: Int] = [:]
    var i = 0
    let length = input.count
    let array = Array(input)
    while i < length {
        // case 1:
        if array[i] == "(" {
            prevStates.append(currState)
            currState = [:]
            i += 1
            print("After ( -- Prev: \(prevStates.description)")
            print("After ( -- Curr: \(currState.description)")
        } else if array[i] == ")" {
            var multiplier = 0
            i += 1
            while i < length, let digit = array[i].wholeNumberValue {
                multiplier = multiplier * 10 + digit
                i += 1
            }
            if var prevState = prevStates.popLast() {
                for key in currState.keys {
                    prevState[key] = (prevState[key] ?? 0) + (currState[key] ?? 0) * multiplier
                }
                currState = prevState
                print("After ) Prev: \(prevStates.description)")
                print("After ) Curr: \(currState.description)")
            }
            
        } else {
            var start = i
            i += 1
            while i < length && array[i].isLowercase {
                i += 1
            }
            let element = String(array[start..<i])
            start = i
            while i < length && array[i].isNumber {
                i += 1
            }
            let count = start < i ? Int(String(array[start..<i])) : 1
            currState[element] = count
        }
    }
    
    let sorted = currState.keys.sorted()
    var result = ""
    for element in sorted {
        result += element
        if let count = currState[element], count > 1 {
            result += String(count)
        }
    }
    return result
}

print(countAtoms("K4(ON(SO3)2)2"))


/*
 Given a encoded string that compressed according to the following rules:
 N[inner_pattern] -> N is a positive integer and the inner pattern will be repeated N times.
 Decompress the encoded string and return the original string.
 Assumptions:
 N is alway positive integer.
 The input is always valid, i.e. the brackets are always in pair.
 The decompressed string (that is the return value) doesn't contain digit or brackets, which means digit, '[' and ']' are only used in encoded (compressed) string.

 Example 1:
 Input: "abc"
 Output: "abc"
 Example 2:
 Input: "ab3[cd[2e]]f"
 Output: "abcdeecdeecdeef"
 */
/// Decompress String III
func decompressString(_ input: String) -> String {
    var strStack = [String]()
    var countStack = [Int]()
    var array = Array(input)
    var index = 0
    var curr = ""
    while index < input.count {
        let char = array[index]
        if char == "[" {
            strStack.append(curr)
            curr = ""
            index += 1
        } else if char == "]" {
            if var prev = strStack.popLast(), let multiplier = countStack.popLast() {
                for i in 0..<multiplier {
                    prev += curr
                }
                curr = prev
            }
            index += 1
        } else if char.isNumber {
            var currCount = 0
            while index < input.count && array[index].isNumber {
                currCount = currCount * 10 + Int(String(array[index]))!
                index += 1
            }
            countStack.append(currCount)
        } else {
            curr += String(char)
            index += 1
        }
    }
    return curr
}
decompressString("ab3[cd[2e]]f")

/*
 Given an absolute path for a file (Unix-style), simplify it.
    Input: path = “/home/”
    Output: “/home”
    Input: path = “/a/./b/../../c/”
    Output: “/c”
 */
/// Simplify Unix Path
func simplifyUnixPath(_ path: String) -> String {
    var stack = [String]()
    let components = path.split(separator: "/")
    for component in components {
        if component == "." || component.isEmpty {
            continue
        }
        if component == ".." {
            if !stack.isEmpty {
                stack.popLast()
            }
        } else {
            stack.append(String(component))
        }
    }
    return "/" + stack.joined(separator: "/")
}

print(simplifyUnixPath("/a/./b/../../c/"))


/*
 Given a string containing just the characters '(' and ')', find the length of the longest valid (well-formed) parentheses substring.
 Example:
 ")()())", where the longest valid parentheses substring is "()()", which has length = 4.
 */
/// Longest Valid Parentheses
func longestValidParentheses(_ s: String) -> Int {
    // stack holds index of the potential start of a consecutive ()s
    // case 1: if s == "("; push the current index to stack
    // case 2: else: stack.pop to match:
    //      2.1: if stack isEmpty: push current index to the stack; as the new start
    //      2.2: stack isNot empty: stack.peek() start of current substring; update
    guard s.count > 0 else { return 0 }
    var stack = [Int]()
    stack.append(-1)
    var result = 0
    for (i, char) in s.enumerated() {
        if char == "(" {
            stack.append(i)
        } else {
            stack.popLast()
            if stack.isEmpty {
                stack.append(i)
            } else {
                result = max(result, i - stack.last!)
            }
        }
    }
    return result
}
longestValidParentheses("((())()))")
