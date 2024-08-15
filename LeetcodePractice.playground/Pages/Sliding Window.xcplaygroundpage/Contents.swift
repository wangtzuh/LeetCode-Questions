
import Foundation

/*
 Given a string, return the longest contiguous substring that contains exactly k type of characters.

 Return null if there does not exist such substring.

 Assumptions:

 The given string is not null and guaranteed to have at least k different characters.
 k > 0.
 Examples:

 input = "aabcc", k = 3, output = "aabcc".
 input = "aabcccc", k = 2, output = "bcccc".
 https://app.laicode.io/app/problem/285
 */

/// Longest Substring With K Typed Characters
func longestSubstring(_ input: String?, with k: Int) -> String {
    guard let input = input, input.count > 0 && k > 0 else { return "" }
    let array = Array(input)
    var currLeft = 0, bestLeft = 0, bestRight = 0
    var map: [Character : Int] = [:]
    for i in 0..<array.count {
        map[array[i], default: 0] += 1
        while map.count > k {
            map[array[currLeft]]! -= 1
            if map[array[currLeft]]! == 0 {
                map.removeValue(forKey: array[currLeft])
            }
            currLeft += 1
        }
        if map.count == k && (bestRight - bestLeft + 1) < (i - currLeft + 1) {
            bestRight = i
            bestLeft = currLeft
        }
    }
    return String(array[bestLeft...bestRight])
}

longestSubstring("dabaaebac", with: 4)

/*
 Given a string, find the length of the longest substring T that contains at most k distinct characters.
 For example, Given s = “eceba” and k = 2,
 T is "ece" which its length is 3.
 */
func longestSubstringLengthDistinct(_ input: String?, with k: Int) -> Int {
    guard let input = input, input.count > 0, k > 0 else { return 0 }
    let array = Array(input)
    var currLeft = 0, maxLength = 0
    var map = [Character : Int]()
    for i in 0..<array.count {
        map[array[i], default: 0] += 1
        while map.count > k {
            if let count = map[array[currLeft]], count == 1 {
                map.removeValue(forKey: array[currLeft])
            } else {
                map[array[currLeft]]! -= 1
            }
            currLeft += 1
        }
        if maxLength < (i - currLeft + 1) {
            maxLength = i - currLeft + 1
        }
    }
    return maxLength
}

longestSubstringLengthDistinct("yysbmhstkxtjarvjiupouikwddhxrtnfsspdmoxzldkcsmfqbhjdlypvoztcgzztveffmkyabbuizcovohynwusmjxtzavvfatsujxkgoxplmnhktezuxcqytlyjfvfhvleqdppejgcvtxtcjgnshzyrhnhsaqvagqdbnk", with: 7)

/*
 Given an array of integers that contains only 0s and 1s and a positive integer k, you can flip at most k 0s to 1s, return the longest subarray that contains only integer 1 after flipping.

 Assumptions:

 1. Length of given array is between [1, 20000].

 2. The given array only contains 1s and 0s.

 3. 0 <= k <= length of given array.

 Example 1:

 Input: array = [1,1,0,0,1,1,1,0,0,0], k = 2

 Output: 7

 Explanation: flip 0s at index 2 and 3, then the array becomes [1,1,1,1,1,1,1,0,0,0], so that the length of longest subarray that contains only integer 1 is 7.

 Example 2:

 Input: array = [1,1,0,0,1,1,1,0,0,0], k = 0

 Output: 3

 Explanation: k is 0 so you can not flip any 0 to 1, then the length of longest subarray that contains only integer 1 is 3.
 https://app.laicode.io/app/problem/625
 */
/// Longest subarray contains only 1s
func longestConsecutiveOnes(_ nums: [Int], k: Int) -> Int {
    // Maintain sliding window; left, right; within the range, [left, right];
    //  there are only at most k 0 zeros;
    // for each iteration;
    //    case 1: if 1; advance right; record currMax; right - left + 1
    //    case 2: if 0: 0amount += 1; 0amount <= k; advance right; record
    //                                else left++; until 0amount == k;
    var result = 0, zeroCount = 0, left = 0, right = 0
    while right < nums.count {
        if nums[right] == 1 {
            result = max(result, right - left + 1)
            right += 1
        } else if zeroCount < k {
            result = max(result, right - left + 1)
            right += 1
            zeroCount += 1
        } else {
            if nums[left] == 0 {
                zeroCount -= 1
            }
            left += 1
        }
    }
    return result
}
longestConsecutiveOnes([1,0,0,1,1,1,0,1,0,1,1,0,1,0,1,1,1,0,1,0,1,1,1,0,0,0,1,1,1,1,1,1,0,0,1,1,1,0,0,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1,1,0,1,0,0,0,1,1,0,1,0,1,0,0,1,1,0,0,1,0,1,0,0,0,1,1,0,0,1,1,1,1,1,1,1,0,1,1,1,0,1,0,0,0,1,0,1,1,1,1,0,0,1,0,1,0,1,1,0,1,0,1,1,0,0,1,1,0,1,1,0,1,1,0,0,0,1,1,1,0,1,0,1,1,1,0,1,1,1,0,1,1,0,1,0,1,0,1,1,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,0,1,1,1,0,0,1,1,1,0,1,1,1,0,0,0,0,0,0,1,0,1,0,1,0,1,1,0,1,0,0,0,1,0,1,1,1,0,1,1,1,0,1,0,1,1,0,1,1,1,1,0,0,0,1,1,1,1,0,1,1,1,0,1,0,0,0,0,0,1,1,1,0,1,0,0,0,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0,1,1,0,0,0,1,0,0,0,0], k: 60)

