import Foundation

// MARK: - BST Validation Related
/*
 Given the root of a binary tree, determine if it is a valid binary search tree (BST).
 https://leetcode.com/problems/validate-binary-search-tree/description/
 */
/// Validate Binary Search Tree
func isValidBST(_ root: TreeNode?) -> Bool {
    return isBSTHelper(root, Int.min, Int.max)
}

private func isBSTHelper(_ root: TreeNode?, _ lowerBound: Int, _ upperBound: Int) -> Bool {
    guard let root = root else { return true }
    if root.value <= lowerBound || root.value >= upperBound { return false }
    return isBSTHelper(root.left, lowerBound, root.value) && isBSTHelper(root.right, root.value, upperBound)
}

/*
 You are given the root of a binary search tree (BST), where the values of exactly two nodes of the tree were swapped by mistake. Recover the tree without changing its structure.
 NOTE: Just Swap the value
 https://leetcode.com/problems/recover-binary-search-tree/description/
 */
/// Recover Binary Search Tree
func recoverTree(_ root: TreeNode?) {
    // For a valid BST, we will get an ascending sequence after inorder traversal.
    // Therefore, while we traverse the tree, maintain previous node, reference to
    // check if the current root's val is less than prev;
    //   if true:
    //       if first wrong node is null, assign prev as it;
    //       set the second node to current root;
    //  case 1: two elements are aligned
    //         prev root
    //       1   3   2   4 5 6
    //  case 2: two elements are apart
    //              prev root
    //       1   2   5    4  6  3   -> wrong0 : 5, wrong1: 4
    //                   prev root
    //       1   2  5  4  6    3    -> wrong0: 5, wrong1: 3
    // Time Complexity: O(n) for tree traversal
    // Space Complexity: O(height): call stacks for recursion
    var prev: TreeNode? = nil
    var wrongNodes: (TreeNode?, TreeNode?) = (nil, nil)
    recoverTreeHelper(root, &prev, &wrongNodes)
    if let first = wrongNodes.0, let second = wrongNodes.1 {
        let temp = first.value
        first.value = second.value
        second.value = temp
    }
}

private func recoverTreeHelper(_ root: TreeNode?, _ prev: inout TreeNode?,  _ wrongNodes: inout (TreeNode?, TreeNode?)) {
    guard let root = root else { return }
    recoverTreeHelper(root.left, &prev, &wrongNodes)
    if let prev = prev, prev.value > root.value {
        if wrongNodes.0 == nil {
            wrongNodes.0 = prev
        }
        wrongNodes.1 = root
    }
    prev = root
    recoverTreeHelper(root.right, &prev, &wrongNodes)
}

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

// MARK: - General BST Operations

/*
 You are given the root node of a binary search tree (BST) and a value to insert into the tree. Return the root node of the BST after the insertion. It is guaranteed that the new value does not exist in the original BST.

 Notice that there may exist multiple valid ways for the insertion, as long as the tree remains a BST after insertion. You can return any of them.
 https://leetcode.com/problems/insert-into-a-binary-search-tree/description/
 */
/// Insert into a Binary Search Tree
func insertIntoBST(_ root: TreeNode?, _ val: Int) -> TreeNode? {
    if root == nil { return TreeNode(val) }
    var root = root
    let returnNode = root
    var prev: TreeNode? = nil
    while root != nil {
        prev = root
        if root!.val > val {
            root = root!.left
        } else if root!.val < val {
            root = root!.right
        } else {
            return returnNode
        }
    }
    if prev!.val < val {
        prev!.right = TreeNode(val)
    } else {
        prev!.left = TreeNode(val)
    }
    return returnNode
}

/*
 Given a root node reference of a BST and a key, delete the node with the given key in the BST. Return the root node reference (possibly updated) of the BST.

 Basically, the deletion can be divided into two stages:

 Search for a node to remove.
 If the node is found, delete the node.
 */
/// Delete Node in a BST
func deleteNode(_ root: TreeNode?, _ key: Int) -> TreeNode? {
    // case 1: no child node for the deleted node; return nil
    // case 2: only contains left; return left
    // case 3: only contains right; return right
    // case 4: contains both left and right:
    //     return the smallest from the right, and connect root.left as right.left
    //    4.1: if right has no left child; right.left = root.left, return right
    //    4.2: find the smallest left on the right; (prev.left = smallest.right)
    //      right.left = root.left, right.right =  root.right;
    guard let root else { return nil }
    if root.val == key {
        if root.left == nil {
            return root.right
        } else if root.right == nil {
            return root.left
        } else if root.right?.left == nil {
            root.right?.left = root.left
            return root.right
        } else {
            let smallest = findSmallestInLeft(root.right)
            smallest?.left = root.left
            smallest?.right = root.right
            return smallest
        }
    }
    if root.val < key {
        root.right = deleteNode(root.right, key)
    } else {
        root.left = deleteNode(root.left, key)
    }
    
    func findSmallestInLeft(_ node: TreeNode?) -> TreeNode? {
        guard var node else { return nil }
        while node.left?.left != nil {
            node = node.left!
        }
        let smallest = node.left
        node.left = smallest?.right
        return smallest
    }
    
    return root
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



/*
 Given the root of a Binary Search Tree (BST), convert it to a Greater Tree such that every key of the original BST is changed to the original key plus the sum of all keys greater than the original key in BST.

 As a reminder, a binary search tree is a tree that satisfies these constraints:

 The left subtree of a node contains only nodes with keys less than the node's key.
 The right subtree of a node contains only nodes with keys greater than the node's key.
 Both the left and right subtrees must also be binary search trees.
 https://leetcode.com/problems/convert-bst-to-greater-tree/description/
 */
/// Convert BST to Greater Tree
func convertBST(_ root: TreeNode?) -> TreeNode? {
    // traverse the tree with right, curr, left order
    // maintain the pathSum; for the curr node, we add the
    // path sum to the root
    guard let root else { return nil }
    func traverse(_ root: TreeNode?, _ sum: inout Int) {
        guard let root else { return }
        traverse(root.right, &sum)
        sum += root.val
        root.val = sum
        traverse(root.left, &sum)
    }
    var sum = 0
    traverse(root, &sum)
    return root
}
 

/*
 Given the root of a binary search tree and the lowest and highest boundaries as low and high, trim the tree so that all its elements lies in [low, high]. Trimming the tree should not change the relative structure of the elements that will remain in the tree (i.e., any node's descendant should remain a descendant). It can be proven that there is a unique answer.

 Return the root of the trimmed binary search tree. Note that the root may change depending on the given bounds.
 https://leetcode.com/problems/trim-a-binary-search-tree/description/
 */
func trimBST(_ root: TreeNode?, _ low: Int, _ high: Int) -> TreeNode? {
    // if root.val < low --> trim all left
    // if root.val > high --> trim all right;
    // else root.left = trimmed leftResult; root.right = trimmed rightResult
    guard let root else { return nil }
    if root.val < low { return trimBST(root.right, low, high) }
    if root.val > high { return trimBST(root.left, low, high) }
    root.left = trimBST(root.left, low, high)
    root.right = trimBST(root.right, low, high)
    return root
}
