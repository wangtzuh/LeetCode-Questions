import Foundation

// MARK: - Find Target in BST
func secondLargestInBST(_ root: TreeNode?) -> Int {
    guard var root = root else { return Int.min }
    var prev: TreeNode? = nil
    while root.right != nil {
        prev = root
        root = root.right!
    }
    if root.left != nil {
        root = root.left!
        while root.right != nil {
            root = root.right!
        }
        return root.value
    }
    return prev?.value ?? Int.min
}

func closestValue(_ root: TreeNode?, _ target: Int) -> Int {
    // Binary Search Method: get the sorted list; then run the binary search
    guard let root = root else { return Int.min }
    var result = root.value
    var node: TreeNode? = root
    
    while let currNode = node {
        if root.value == target { return root.value }
        if abs(result - target) > abs(root.value - target) {
            result = root.value
        }
        if currNode.value < target {
            node = currNode.left
        } else {
            node = currNode.right
        }
    }
    return result
    
    
    func binarySearch(_ root: TreeNode, _ target: Int) -> Int {
        var result = [Int]()
        inOrder(root, &result)
        let closestIndex = findClosestIndex(result, target)
        return result[closestIndex]
    }
    
    
}

private func inOrder(_ root: TreeNode?, _ result: inout [Int]) {
    guard var root = root else { return }
    inOrder(root.left, &result)
    result.append(root.value)
    inOrder(root.right, &result)
}

private func findClosestIndex(_ array: [Int], _ target: Int) -> Int {
    var left = 0, right = target - 1
    while left < right - 1 {
        let mid = left + (right - left) / 2
        if array[mid] == target {
            return mid
        } else if array[mid] < target {
            left = mid
        } else {
            right = mid
        }
    }
    if abs(array[left] - target) < abs(array[right] - target) {
        return left
    } else {
        return right
    }
}

func closestKValues(_ root: TreeNode?, _ target: Int, _ k: Int) -> [Int] {
    guard let root = root else { return [] }
    var sortedArray = [Int]()
    inOrder(root, &sortedArray)
    if k >= sortedArray.count { return sortedArray }
    if k <= 1 { return Array(sortedArray[0..<1]) } // avoid lower bound >= upper bound issue
    
    func binarySearch(_ array: [Int], _ target: Int, _ k: Int) -> [Int] {
        let index = findClosestIndex(array, target)
        var result = Array(repeating: 0, count: k)
        result[0] = array[index]
        var left = index - 1, right = index + 1
        for i in 1..<k - 1 {
            if left < 0 {
                result[i] = array[right]
                right += 1
            } else if right >= result.count {
                result[i] = array[left]
                left -= 1
            } else {
                if abs(array[left] - target) < abs(array[right] - target) {
                    result[i] = array[left]
                    left -= 1
                } else {
                    result[i] = array[right]
                    right += 1
                }
            }
        }
        return result
    }
    
    func slidingWindow(_ array: [Int], _ target: Int, _ k: Int) -> [Int] {
        var left = 0, right = k - 1
        // determine the right and left bound for the sliding window:
        // if a[right + 1] - target > a[left] - target; means reach the target range
        while right + 1 < array.count {
            if abs(array[right + 1] - target) < abs(array[left] - target) {
                right += 1
                left += 1
            } else {
                break
            }
        }
        var result = Array(repeating: 0, count: k)
        for i in left..<result.count {
            result[i] = array[left]
            left += 1
        }
        return result
    }
    
    func prefixSum(_ array: [Int], _ target: Int, _ k: Int) -> [Int] {
        return []
    }
    return []
}


// MARK: - BST Reconstruction
func sortedArrayToBST(_ array: [Int]) -> TreeNode {
    guard array.count > 1 else { return TreeNode(value: array.first!) }
    var root = TreeNode(value: array.first!)
    var index = 1
    return helper(array, 0, array.count - 1)!
    func helper(_ array: [Int], _ left: Int, _ right: Int) -> TreeNode? {
        if left >= right {
            return nil
        }
        let mid = left + (right - left) / 2
        let curr = TreeNode(value: array[mid])
        root.left = helper(array, left, mid - 1)
        root.right = helper(array, mid + 1, right)
        return curr
    }
}

/*
 Given the levelorder traversal sequence of a binary search tree, reconstruct the original tree.
 */
func levelByLevelToBST(_ array: [Int]) -> TreeNode? {
    guard array.count == 0 else { return nil }
    var index = 0
    let root = TreeNode(value: array[0])
    index += 1
    var queue = [root]
    var lowBound = [Int.min]
    var highBound = [Int.max]
    while index < array.count {
        let curr = queue.removeFirst()
        let low = lowBound.removeFirst()
        let high = highBound.removeFirst()
        
        if index < array.count && array[index] > low && array[index] < curr.value {
            curr.left = TreeNode(value: array[index])
            lowBound.append(low)
            highBound.append(curr.value)
            index += 1
        }
        
        if index < array.count && array[index] > curr.value && array[index] < high {
            curr.right = TreeNode(value: array[index])
            lowBound.append(curr.value)
            highBound.append(high)
            index += 1
        }
    }
    return root
}

/// Reconstruct Binary Search Tree With Preorder Traversal
func reconstructPre(_ pre: [Int]) -> TreeNode? {
    guard pre.count > 0 else { return nil }
    var currIndex = 0
    return helperPre(pre, &currIndex, Int.min, Int.max)
}

private func helperPre(_ pre: [Int], _ index: inout Int, _ min: Int, _ max: Int) -> TreeNode? {
    if index >= pre.count { return nil }
    let value = pre[index]
    if value < min || value > max { return nil }
    let currNode = TreeNode(value: value)
    index += 1
    currNode.left = helperPre(pre, &index, min, value)
    currNode.right = helperPre(pre, &index, currNode.value, max)
    return currNode
}

/*
 Given the postorder traversal sequence of a binary search tree, reconstruct the original tree.
 */
/// Reconstruct Binary Search Tree With Postorder Traversal
func reconstructPost(_ post: [Int]) -> TreeNode? {
    guard post.count > 0 else { return nil }
    var currIndex = post.count - 1
    return postHelper(post, &currIndex, Int.min, Int.max)
}

private func postHelper(_ post: [Int], 
                        _ currIndex: inout Int,
                        _ min: Int,
                        _ max: Int) -> TreeNode? {
    if currIndex < 0 { return nil }
    let value = post[currIndex]
    if value < min || value > max { return nil }
    let currNode = TreeNode(value: value)
    currIndex -= 1
    currNode.right = postHelper(post, &currIndex, value, max)
    currNode.left = postHelper(post, &currIndex, min, value)
    return currNode
}

reconstructPost([1,2,3])


func reconstructInPre(_ inOrder: [Int], _ preOrder: [Int]) -> TreeNode? {
    guard inOrder.count > 0 else { return nil }
    let indexMap = createIndexMap(inOrder)
    return inPreHelper(inOrder, preOrder, indexMap, 0, inOrder.count - 1, 0, preOrder.count - 1)
}

private func inPreHelper(_ inOrder: [Int], 
                         _ preOrder: [Int],
                         _ indexMap: [Int: Int],
                         _ inLeft: Int,
                         _ inRight: Int,
                         _ preLeft: Int,
                         _ preRight: Int) -> TreeNode? {
    if inLeft > inRight { return nil }
    let currNode = TreeNode(value: preOrder[preLeft])
    let inMid = indexMap[currNode.value]!
    currNode.left = inPreHelper(inOrder,
                                preOrder,
                                indexMap,
                                inLeft,
                                inMid - 1,
                                preLeft + 1,
                                preLeft + inMid - inLeft)
    currNode.right = inPreHelper(inOrder,
                                 preOrder,
                                 indexMap,
                                 inMid + 1,
                                 inRight,
                                 preLeft + inMid - inLeft + 1,
                                 preRight)
    return currNode
}

private func createIndexMap(_ inOrder: [Int]) -> [Int:Int] {
    var dict = [Int : Int]()
    for i in 0..<inOrder.count {
        dict[inOrder[i]] = i
    }
    return dict
}

func reconstructInPo(_ inOrder: [Int], _ poOrder: [Int]) -> TreeNode? {
    return nil
}

func reconstructInLevel(_ inOrder: [Int], _ levelOrder: [Int]) -> TreeNode? {
    return nil
}


func kthSmallestInBST(_ root: TreeNode, _ k: Int) -> Int {
    return 0
}

