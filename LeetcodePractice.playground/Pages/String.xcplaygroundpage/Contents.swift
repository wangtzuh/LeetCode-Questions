import Foundation

/// Valid palindrome
/// Given a string, determine if it is a palindrome, considering only alphanumeric characters('0'-'9','a'-'z','A'-'Z') and ignoring cases.
func isPalindrome(input: String) -> Bool {
    guard !input.isEmpty || input.count > 1 else { return true }
    let array = Array(input.lowercased())
    var left = 0, right = array.count - 1
    while left < right {
        if !isValidChar(array[left]) {
            left += 1
            continue
        }
        if !isValidChar(array[right]) {
            right -= 1
            continue
        }
        
        if array[left] != array[right] {
            return false
        }
        left += 1
        right -= 1
    }
    return true
    
    func isValidChar(_ char: Character) -> Bool {
        return char.isLetter || char.isNumber
    }
}
isPalindrome(input: "")
isPalindrome(input: "abc")
isPalindrome(input: "aba #")


/// Valid palindrome II
/// Given a non-empty string s, you may delete at most one character. Judge whether you can make it a palindrome.
/* Example 1:
    Input: "aba"
    Output: True
    Example 2:

    Input: "abca"
    Output: True
    Explanation: You could delete the character 'c'.
 */
func validPalindrome(input: String) -> Bool {
    guard !input.isEmpty || input.count > 1 else { return true }
    
    var array = Array(input)
    var left = 0, right = array.count - 1
    while left < right {
        if array[left] == array[right] {
            left += 1
            right -= 1
        } else {
            return helper(input: array, left: left + 1, right: right, hasDeleted: true) || helper(input: array, left: left, right: right - 1, hasDeleted: true)
        }
    }
    return true
    
    func helper(input: [Character], left: Int, right: Int, hasDeleted: Bool) -> Bool {
        if left >= right {
            return true
        }
        if array[left] != array[right] {
            if hasDeleted { return false }
            return helper(input: input, left: left, right: right - 1, hasDeleted: true) || helper(input: input, left: left + 1, right: right, hasDeleted: true)
        }
        return helper(input: input, left: left + 1, right: right - 1, hasDeleted: true)
    }
}

validPalindrome(input: "abcd")
validPalindrome(input: "abac")

/// Length of the Last Word
/// Given a string s consists of upper/lower-case alphabets and empty space characters ' ', return the length of last word in the string.
/*
    Input: s = “Hello World   “
    Output: 5
*/
func lenOfLast(input: String) -> Int {
    // Simple trim and get Array[String] by components API
    // return input.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).last?.count ?? 0
    let array = Array(input)
    var right = array.count - 1
    for i in (0...array.count - 1).reversed() {
        if array[right] == " " {
            right -= 1
        } else if array[i] == " " {
            return right - i
        }
    }
    return right + 1
}

lenOfLast(input: "aaa bbb ccc  ddddd     ")



/*
 Given a non-negative integer N, find the largest number that is less than or equal to Nwith monotone increasing digits.

 (Recall that an integer has monotone increasing digits if and only if each pair of adjacent digits x and y satisfy x <= y.)

 Example 1:

 Input: N = 10
 Output: 9
 Example 2:

 Input: N = 1234
 Output: 1234
 Example 3:

 Input: N = 332
 Output: 299
 Note: N is an integer in the range [0, 10^9].
 */
/// Monotone Increasing Digits
func monotonIncreasingDigits(_ num: Int) -> Int {
    var digits = Array(String(num))
    var mark = digits.count
    for i in (1..<digits.count).reversed() {
        if digits[i] < digits[i - 1] {
            mark = i
            digits[i - 1] = Character(UnicodeScalar(digits[i - 1].asciiValue! - 1))
        }
    }
    for i in mark..<digits.count {
        digits[i] = "9"
    }
    return Int(String(digits))!
}

monotonIncreasingDigits(1234)
monotonIncreasingDigits(332)
monotonIncreasingDigits(10)


/*
 Assumptions:
    The string is not null
    The characters used in the original string are guaranteed to be ‘a’ - ‘z’
    There are no adjacent repeated characters with length > 9
    Examples
 Examples:
 “acb2c4” → “acbbcccc”
 */
/// Decompress String I
func decompressString(_ s: String) -> String {
    guard s.count > 1 else { return s }
    var result = ""
    var array = Array(s)
    var index = 0
    while index < s.count {
        let curr = array[index]
        index += 1
        if index < s.count, let count = Int(String(array[index])) {
            for i in 0..<count {
                result += String(curr)
            }
            index += 1
        } else {
            result += String(curr)
        }
    }
    return result
}

decompressString("ap2lec3n")

/*
 Assumptions

 The string is not null
 The characters used in the original string are guaranteed to be ‘a’ - ‘z’
 There are no adjacent repeated characters with length > 9
 Examples

 “a1c0b2c4” → “abbcccc”

 */
/// Decompress String II
func decompressStringII(_ s: String) -> String {
    guard s.count > 1 else { return s }
    var index = 0
    var result = ""
    var array = Array(s)
    while index < s.count {
        let curr = array[index]
        index += 1
        if let count = Int(String(array[index])) {
            for i in 0..<count {
                result += String(curr)
            }
        }
        index += 1
    }
    return result
}
decompressStringII("x2y0i0z3")
