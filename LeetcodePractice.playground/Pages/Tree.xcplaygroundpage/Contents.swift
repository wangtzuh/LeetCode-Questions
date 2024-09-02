
import Foundation

// MARK: - Path Sum Related

/*
 Given the root of a binary tree and an integer targetSum, return true if the tree has a root-to-leaf path such that adding up all the values along the path equals targetSum.
 https://leetcode.com/problems/path-sum/
 */
func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
    guard let root else { return false }
    if root.left == nil && root.right == nil { return targetSum - root.value == 0 }
    return hasPathSum(root.left, targetSum - root.value) || hasPathSum(root.right, targetSum - root.value)
}
/*
 113. Path Sum II
 Solved
 Medium

 Topics
 Companies
 Given the root of a binary tree and an integer targetSum, return all root-to-leaf paths where the sum of the node values in the path equals targetSum. Each path should be returned as a list of the node values, not node references.
 https://leetcode.com/problems/path-sum-ii/description/
 */

func pathSum(_ root: TreeNode?, _ targetSum: Int) -> [[Int]] {
    // C: Must need a Root to Leaf path; return the path traversal from top to bottom;
    // Recursion to pass the current targetSum from top to bottom, and verify the pathSum at the leafnode
    // Base case:
    //  if root.left == nil && root.right == nil; check pathSum == targetSum - root.val;
    //  path.append.root.val;
    //  go left; go right
    //  path.removeLast;
    // Time: O(n) as tree traversal
    // Space: O(height) as recursion call stacks
    guard let root else { return [] }
    var currPath = [Int]()
    var result = [[Int]]()
    pathSumHelper(root, 0, targetSum, &currPath, &result)
    return result
}

func pathSumHelper(_ root: TreeNode? , _ pathSum: Int, _ targetSum: Int, _ currPath: inout [Int], _ result: inout [[Int]]) {
    guard let root else { return }
    if root.left == nil && root.right == nil {
        if targetSum - root.value == pathSum {
            currPath.append(root.value)
            result.append(currPath)
            currPath.removeLast()
        }
        return
    }
    currPath.append(root.value)
    pathSumHelper(root.left, pathSum + root.value, targetSum, &currPath, &result)
    pathSumHelper(root.right, pathSum + root.value, targetSum, &currPath, &result)
    currPath.removeLast()
}

/*
 A path in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. A node can only appear in the sequence at most once. Note that the path does not need to pass through the root.

 The path sum of a path is the sum of the node's values in the path.

 Given the root of a binary tree, return the maximum path sum of any non-empty path.

 */
/// Find tha Max Path Sum from Node to Node
func maxPathSum(_ root: TreeNode?) -> Int {
    // Node to node, including single node;
    // Use recursion to return the maxPath Sum from bottom to top;
    // Left Child: max path sum (single path) including left
    // Right child max path sum including right;
    // Current node:
    //    1. both left, right are positive -> form a ^ path including root;
    //    2. only one is positive -> connect root to the positive path
    //    3. both are negative, consider root as the max path sum;
    // Return to parent:
    //    1. if both are negative; return root;
    //    2. if either one is positive, return root + the positive path
    //    3. if both are positive, return the greater onel
    var result = Int.min
    maxPathSumHelper(root, &result)
    return result == Int.min ? 0 : result
}

private func maxPathSumHelper(_ root: TreeNode?, _ result: inout Int) -> Int? {
    guard let root else { return nil }
    let leftResult = maxPathSumHelper(root.left, &result) ?? 0
    let rightResult = maxPathSumHelper(root.right, &result) ?? 0
    if leftResult >= 0 && rightResult >= 0 {
        result = max(result, leftResult + rightResult + root.value)
        return max(leftResult, rightResult) + root.value
    } else if leftResult >= 0 || rightResult >= 0 {
        result = max(result, max(leftResult, rightResult) + root.value)
        return max(leftResult, rightResult) + root.value
    } else {
        result = max(result, root.value)
        return root.value
    }
}

/*
 You are given the root of a binary tree containing digits from 0 to 9 only.

 Each root-to-leaf path in the tree represents a number.

 For example, the root-to-leaf path 1 -> 2 -> 3 represents the number 123.
 Return the total sum of all root-to-leaf numbers. Test cases are generated so that the answer will fit in a 32-bit integer.

 A leaf node is a node with no children.
 https://leetcode.com/problems/sum-root-to-leaf-numbers/description/
 */
func sumNumbers(_ root: TreeNode?) -> Int {
    // recursively traverse the tree from top to bottom, and pass the current path value to next level
    // once reach the leaf node, add the currPath value to the result
    // restore the currPath when backtracking
    // to the result
    // Time Complexity: O(n)
    // Space Complexity: O(Height)
    var result = 0
    sumNumbersHelper(root, 0, &result)
    return result
}

private func sumNumbersHelper(_ root: TreeNode?, _ currPath: Int, _ result: inout Int) {
    guard let root else { return }
    if root.left == nil && root.right == nil {
        var currPath = currPath * 10 + root.value
        result += currPath
        return
    }
    var currPath = currPath * 10 + root.value
    if let left = root.left {
        sumNumbersHelper(left, currPath, &result)
    }
    if let right = root.right {
        sumNumbersHelper(right, currPath, &result)
    }
}


/*
 Given the root of a binary tree and an integer targetSum, return the number of paths where the sum of the values along the path equals targetSum.

 The path does not need to start or end at the root or a leaf, but it must go downwards (i.e., traveling only from parent nodes to child nodes).
 https://leetcode.com/problems/path-sum-iii/description/
 */
/// Path Sum III
func pathSum(_ root: TreeNode?, _ targetSum: Int) -> Int {
    // maintain a Map<prefixSum, count> while we traverse the array; preorder; left, right, root order
    // whenever there exist a previous prefixSum - targetSum; means there is a path that equal to the target sum
    //  10 -> 15 -> 17 -> 18 (18 - 8) == 10; exist in map;
    // therefore -> Recursion
    //  base case: root == nil; return
    //  recursive method:
    //      1. prefixSum += root.val
    //      2. if map[prefixSum] != 0; result += map[prefixSum]
    //      3. recursion(root.left || root.right, prefixSum, targetSum)
    //      4. map[prefixSum] -= 1; for backtracking
    // Time: O(n) in average; n^2 for the worst case for map lookup
    guard let root else { return 0}
    var prefixSumMap = [0 : 1]
    var result = 0
    
    func pathSumHelper(_ root: TreeNode?, _ prefixSum: Int, _ targetSum: Int) {
        guard let root else { return }
        var prefixSum = prefixSum + root.val
        if let occurs = prefixSumMap[prefixSum - targetSum] {
            result += occurs
        }
        prefixSumMap[prefixSum, default: 0] += 1
        pathSumHelper(root.left, prefixSum, targetSum)
        pathSumHelper(root.right, prefixSum, targetSum)
        prefixSumMap[prefixSum]! -= 1
    }
    
    pathSumHelper(root, 0, targetSum)
    return result
}


/*
 Given the root of a binary tree, return the length of the longest path, where each node in the path has the same value. This path may or may not pass through the root.

 The length of the path between two nodes is represented by the number of edges between them.
 https://leetcode.com/problems/longest-univalue-path/description/
 */
/// Longest Univalue Path
func longestUnivaluePath(_ root: TreeNode?) -> Int {
    guard let root else { return 0 }
    var res = 0
    helper(root)
    return res
    
    func helper(_ root: TreeNode?) -> Int {
        guard let root else { return 0}
        var leftRes = helper(root.left)
        var rightRes = helper(root.right)
        leftRes = root.left?.val == root.val ? leftRes + 1 : 0
        rightRes = root.right?.val == root.val ? rightRes + 1 : 0
        res = max(leftRes + rightRes, res)
        return max(leftRes, rightRes)
    }
}




// MARK: - Tree Traversal + varients
/*
 Given the root of a binary search tree, rearrange the tree in in-order so that the leftmost node in the tree is now the root of the tree, and every node has no left child and only one right child.
 https://leetcode.com/problems/increasing-order-search-tree/submissions/1372155320/
 */
/// Increasing Order BST
func increasingBST(_ root: TreeNode?) -> TreeNode? {
    guard let root else { return nil }
    var prev: TreeNode? = nil
    
    func helper(_ root: TreeNode?) -> TreeNode? {
        guard let root else { return nil }
        let newRoot = helper(root.left)
        if let prev {
            prev.right = root
        }
        prev = root
        root.left = nil
        helper(root.right)
        return newRoot ?? root
    }
    
    return helper(root)
}

/*
 Given the root of a binary tree, flatten the tree into a "linked list":

 The "linked list" should use the same TreeNode class where the right child pointer points to the next node in the list and the left child pointer is always null.
 The "linked list" should be in the same order as a pre-order traversal of the binary tree.
 https://leetcode.com/problems/flatten-binary-tree-to-linked-list/description/
 */
func flatten(_ root: TreeNode?) {
    guard let root else { return }
    var prev: TreeNode? = nil
    flattenHelper(root, &prev)
}

private func flattenHelper(_ root: TreeNode?, _ prev: inout TreeNode?) {
    guard let root else { return }
    flattenHelper(root.right, &prev)
    flattenHelper(root.left, &prev)
    root.right = prev
    root.left = nil
    prev = root
}

/*
 You are given a perfect binary tree where all leaves are on the same level, and every parent has two children. The binary tree has the following definition:

 struct Node {
   int val;
   Node *left;
   Node *right;
   Node *next;
 }
 Populate each next pointer to point to its next right node. If there is no next right node, the next pointer should be set to NULL.

 Initially, all next pointers are set to NULL.
 https://leetcode.com/problems/populating-next-right-pointers-in-each-node/
 */
func connect(_ root: NodeWithNext?) -> NodeWithNext? {
    // Traverse the tree level by level with a Queue
    // For each iteration:
    //      let size = queue.count
    //      var prev = nil
    //      for index in 0..<size
    //         Expand: let curr = queue.first
    //             if index < count - 1; (exclude the last node); curr.next = queue.first
    //         Generate:
    //              if let left = curr.left; queue.append left
    //              if let right = curr.right; queue.append right
    guard let root else { return nil }
    var queue = [NodeWithNext]()
    queue.append(root)
    while !queue.isEmpty {
        let count = queue.count
        for index in 0..<count {
            let curr = queue.removeFirst()
            if index < count - 1 {
                curr.next = queue.first
            }
            if let left = curr.left {
                queue.append(left)
            }
            if let left = curr.left {
                queue.append(left)
            }
        }
    }
    return root
}

/*
 Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.
 https://leetcode.com/problems/binary-tree-right-side-view/description/
 */
/// Find the Right Side View of the Tree
func rightSideView(_ root: TreeNode?) -> [Int] {
    // use BFS to traverse the input tree level by level.
    // Data Structure: FIFO queue
    // Init: queue = { root }
    // Expand: for each level, queue.count
    //      queue.removeLast; whenever it is the last one, append to final result
    // Generate:
    //      if root.left || root.right != null; queue.offer(child)
    // Termination: queue.isEmpty --> all node has been traversed
    // Time: O(n)
    // Space: O(n)
    
    guard let root else { return [] }
    var queue = [root]
    var result = [Int]()
    while !queue.isEmpty {
        let temp = queue
        queue = []
        result.append(temp.last!.value)
        for node in temp {
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
    }
    return result
}


/*
 Given the root of a binary tree, return an array of the largest value in each row of the tree (0-indexed).
 https://leetcode.com/problems/find-largest-value-in-each-tree-row/description/
 */
/// Find Largest Value in Each Tree Row
func largestValues(_ root: TreeNode?) -> [Int] {
    // level by level traversal with a queue; for each level, find the max; then
    // append to the result
    guard let root else { return [] }
    var result = [Int]()
    var queue = [root]
    while !queue.isEmpty {
        let size = queue.count
        var currMax = Int.min
        for _ in 0..<size {
            let currNode = queue.removeFirst()
            if currNode.val > currMax {
                currMax = currNode.val
            }
            if let left = currNode.left {
                queue.append(left)
            }
            if let right = currNode.right {
                queue.append(right)
            }
        }
        result.append(currMax)
    }
    return result
}

/*
 You are given the root of a binary tree with n nodes, where each node is uniquely assigned a value from 1 to n. You are also given a sequence of n values voyage, which is the desired pre-order traversal of the binary tree.
 https://leetcode.com/problems/flip-binary-tree-to-match-preorder-traversal/description/
 */
/// Flip Binary Tree To Match Preorder Traversal
func flipMatchVoyage(_ root: TreeNode?, _ voyage: [Int]) -> [Int] {
    // Maintain an index while running preorder traversal;
    // whenever we encounter the case root.left.val != voyage[index + 1]; then we mark the
    // root contains the "flipped" nodes, we reverse the order of traversal into right, left;
    // if we can matched all the nodes after the flipped node with preorder, then we found ans.
    // else if
    // the rest of nodes can not been matched; we return false;
    // if there is no flipped nodes, then we return empty or [-1] based on the matched results
    //  base case:
    //      root == nil; return true
    //  recursive rule:
    //      if left.val != yoyage[index]; recursion(root.right), recursion(root.left)
    //      else continue preorder
    guard let root else { return [-1] }
    var res = [Int]()
    var index = 0
    if helper(root) {
        return res
    }
    return [-1]
    
    func helper(_ root: TreeNode?) -> Bool {
        guard let root else { return true }
        guard root.val == voyage[index] else { return false }
        index += 1
        
        if let left = root.left, left.val != voyage[index] {
            res.append(root.val)
            return helper(root.right) && helper(root.left)
        } else {
            return helper(root.left) && helper(root.right)
        }
    }
}

// MARK: - LCA
/*
 Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree.
 https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/description/
 */
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    // Return LCA means
    //  1. nil current node is neither LCA, or the node of p q
    //  2. p or q -> q is under p, or p is under q; or its p or q
    //  3. other node: the lca for p and q
    guard let root, let p, let q  else { return nil }
    
    if root.value == p.value || root.value == q.value { return root }
    let leftLca = lowestCommonAncestor(root.left, p, q)
    let rightLca = lowestCommonAncestor(root.right, p, q)
    if leftLca != nil && rightLca != nil {
        return root
    } else {
        return leftLca == nil ? rightLca : leftLca
    }
}

// MARK: - Tree Construction
/*
 Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct and return the binary tree.
 */
/// Construct Binary Tree from Preorder and Inorder Traversal
func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    // for the preOrder, the first element is the root node; therefore, we can find
    // out a way to recursively set the range of the preorder for each reconstruction.
    // inOrder: use as indexMap, and to find the element count for left and right subtree
    // preOrder: use to define the root reference and the range of left,right
    // inLeft, inRight, map, preLeft, preRight
    // base case:
    //  preLeft > preRight; return nil
    // for each recursion:
    //  root = TreeNode(preOrder[left])
    //  let leftCount = map[preOrder[left]] - inLeft
    //  root.left = helper(inLeft, preOrder[left] - 1, map, preLeft + 1,  preLeft + 1 + leftCount)
    //  root.rgiht = helper(preOrder[left] + 1, inRight, map, preLeft + leftCount, preRight)

    guard preorder.count == inorder.count else { return nil }
    let indexMap = makeIndexMap(inorder)

    func makeIndexMap(_ inorder: [Int]) -> [Int:Int] {
        var result = [Int:Int]()
        for i in 0..<inorder.count {
            result[inorder[i]] = i
        }
        return result
    }

    func helper(_ preorder: [Int], _ preLeft: Int, _ preRight: Int, _ indexMap: [Int:Int], _ inorder: [Int], _ inLeft: Int, _ inRight: Int) -> TreeNode? {
        guard preLeft <= preRight else { return nil }
        let root = TreeNode(preorder[preLeft])
        let inMid = indexMap[root.val]!
        let leftCount = inMid - inLeft
        root.left = helper(preorder, preLeft + 1, preLeft + leftCount, indexMap, inorder,
        inLeft, inMid - 1)
        root.right = helper(preorder, preLeft + leftCount + 1, preRight, indexMap, inorder,
        inMid + 1, inRight)
        return root
    }
    
    return helper(preorder, 0, preorder.count - 1, indexMap, inorder, 0, inorder.count - 1)
}

/*
 Given two integer arrays inorder and postorder where inorder is the inorder traversal of a binary tree and postorder is the postorder traversal of the same tree, construct and return the binary tree.
 https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/description/
 */
/// Construct Binary Tree from Inorder and Postorder Traversal
func buildTreeInPo(_ inorder: [Int], _ postorder: [Int]) -> TreeNode? {
    // similar as using the preOrder one, the reference of the root is the rightmost
    // of the post order; we indeed use the rightCount to determine the subrange
    // for the recursive methods.
    // 1. create indexMap for inorder;
    // 2. poLeft, poRight as the reference of the range; inOrder use to find
    //    the count for the left, right subtree counts
    // 3. recursive calls:
    //      root = TreeNode(postOrder.last!)
    //      inMid = map[root.val]!
    //      leftCount = inMid - inLeft
    //      rightCount = inRight - inMid
    //      root.left = helper(inLeft, inMid - 1, poLeft, poRight - rightCount - 1)
    //      root.right = helper(inMid + 1, inRight, poRight - rightCount, poRight - 1)
    guard inorder.count == postorder.count else { return nil }
    let indexMap = makeIndexMap(inorder)
    
    func makeIndexMap(_ inorder: [Int]) -> [Int: Int]{
        var result = [Int: Int]()
        for i in 0..<inorder.count {
            result[inorder[i]] = i
        }
        return result
    }

    func helper(_ poLeft: Int, _ poRight: Int, _ inLeft: Int, _ inRight: Int) -> TreeNode? {
        guard poLeft <= poRight else { return nil }
        let root = TreeNode(postorder[poRight])
        let inMid = indexMap[root.val]!
        let rightCount = inRight - inMid
        root.right = helper(poRight - rightCount, poRight - 1, inMid + 1, inRight)
        root.left = helper(poLeft, poRight - rightCount - 1, inLeft, inMid - 1)
        return root
    }
    
    return helper(0, postorder.count - 1, 0, inorder.count - 1)
}


/*
 Given two integer arrays, preorder and postorder where preorder is the preorder traversal of a binary tree of distinct values and postorder is the postorder traversal of the same tree, reconstruct and return the binary tree.
 https://leetcode.com/problems/construct-binary-tree-from-preorder-and-postorder-traversal/description/
 */
/// Construct Binary Tree from Preorder and Postorder Traversal
func buildTreePrePost(_ preorder: [Int], _ postorder: [Int]) -> TreeNode? {
    return nil
}



/*
 You are given an integer array nums with no duplicates. A maximum binary tree can be built recursively from nums using the following algorithm:

 1. Create a root node whose value is the maximum value in nums.
 2. Recursively build the left subtree on the subarray prefix to the left of the maximum value.
 3. Recursively build the right subtree on the subarray suffix to the right of the maximum value.
 Return the maximum binary tree built from nums.
 https://leetcode.com/problems/maximum-binary-tree/description/
 */
/// Maximum Binary Tree
func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    // recursive construct the binaryTree; convert array into an indexmap for faster lookup;
    // start from 0...last; find the greatest element as i;
    // root = TreeNode(nums[i]); 0...i-1 range of left subtree; i+1...end; rightSubtree
    // root.left = recursion(left, i-1); root.right = recursion(i+1, right)
    // Recursion core: recursion(_ left: Int, _ right: Int) -> TreeNode?
    //  1. base case: left > right; return nil
    guard nums.count > 0 else { return nil }
    let indexMap = createIndexMap(nums)
    return helper(0, nums.count - 1)

    func helper(_ left: Int, _ right: Int) -> TreeNode? {
        guard left <= right else { return nil }
        let midIndex = indexMap[findGreatestInNums(left, right)]!
        let root = TreeNode(nums[midIndex])
        root.left = helper(left, midIndex - 1)
        root.right = helper(midIndex + 1, right)
        return root
    }

    func findGreatestInNums(_ left: Int, _ right: Int) -> Int {
        var res = nums[left]
        var left = left
        while left <= right {
            res = max(nums[left], res)
            left += 1
        }
        return res
    }

    func createIndexMap(_ nums: [Int]) -> [Int: Int] {
        var res = [Int: Int]()
        for i in 0..<nums.count {
            res[nums[i]] = i
        }
        return res
    }
}


// MARK: - Other
/*
 Given an integer n, return all the structurally unique BST's (binary search trees), which has exactly n nodes of unique values from 1 to n. Return the answer in any order.
 */
func genertateTrees(_ n: Int) -> [TreeNode?] {
    // Recursively construct the tree with left bound and right bound passed from parent
    // for each recursive method, we iterate through i in left...right; where i the
    // root node for this recursive call; then we have the construct
    if n <= 0 { return [] }
    if n <= 1 { return [ TreeNode(value: 1)] }
    
    func helper(_ left: Int, _ right: Int) -> [TreeNode?] {
        guard left <= right else {
            return [nil]
        }
        var result = [TreeNode]()
        for i in left...right {
            let lefts = helper(left, i - 1)
            let rights = helper(i + 1, right)

            for left in lefts {
                for right in rights {
                    let root = TreeNode(value: i)
                    root.left = left
                    root.right = right
                    result.append(root)
                }
            }
        }
        return result
    }
    return helper(1, n)
}

/*
 Given an integer n, return a list of all possible full binary trees with n nodes. Each node of each tree in the answer must have Node.val == 0.

 Each element of the answer is the root node of one possible tree. You may return the final list of trees in any order.

 A full binary tree is a binary tree where each node has exactly 0 or 2 children.
 https://leetcode.com/problems/all-possible-full-binary-trees/description/
 */
/// All Possible Full Binary Trees
func allPossibleFBT(_ n: Int) -> [TreeNode?] {
    // 1. full binary tree requires odd nodes;
    // Recursion core:
    // base case:
    //    1. if n == 1; reutrn [TreeNode(0)]
    //    2. if n is even; return empty list
    // recursive rule:
    //    lefts = all possible binary tree from 1...n; (generate the tree with i nodes)
    //    rights = all possible tree generated with 1...n - i nodes;
    //    for each left subtress;
    //      for each right subtress;
    //          create a new root and connect those; to form trees
    //     return the list
    var map: [Int: [TreeNode]] = [:]
    return helper(n)
    func helper(_ n: Int) -> [TreeNode?] {
        guard n % 2 == 1, n >= 0 else { return [] }
        
        if let found = map[n] { return found }
        if n == 1 { return [TreeNode(0)] }
        
        var result = [TreeNode]()
        for i in 1...n {
            let lefts = allPossibleFBT(i - 1)
            let rights = allPossibleFBT(n - i)
            
            for left in lefts {
                for right in rights {
                    let root = TreeNode(0)
                    root.left = left
                    root.right = right
                    result.append(root)
                }
            }
        }
        map[n] = result
        return result
    }
}


/*
 The thief has found himself a new place for his thievery again. There is only one entrance to this area, called root.

 Besides the root, each house has one and only one parent house. After a tour, the smart thief realized that all houses in this place form a binary tree. It will automatically contact the police if two directly-linked houses were broken into on the same night.

 Given the root of the binary tree, return the maximum amount of money the thief can rob without alerting the police.
 https://leetcode.com/problems/house-robber-iii/description/
 */
/// House Robber III
func rob(_ root: TreeNode?) -> Int {
    // recursively construct the maxPath from bottom to top
    // for the current level --  2 cases
    //  1. rob current room: therefore, the only options we can
    //     consider from the previous results are the max result without robbing
    //     the previous level
    //  2. do not rob current:
    //     2.1 consider robbing the previsou room
    //     2.2 not robbing the previous room
    //  Therefore: we need to return two cases: withRoot, and withoutRoot
    //     1. wihtRoot = root.val + withoutRoot(left), withoutRootRight
    //     2. withoutRoot = max(withRoot(left), withoutRoot(right)) +
    //                      max(withRoot(right), withoutRoot(right))
    //  Time: O(n)
    //  Space: O(h)

    guard let root else { return 0 }
    
    func helper(_ root: TreeNode?) -> (withRoot: Int, withoutRoot: Int) {
        guard let root else { return (0, 0)}
        let left = helper(root.left)
        let right = helper(root.right)
        var result = (withRoot: 0, withoutRoot: 0)
        result.withRoot = root.val + left.withoutRoot + right.withoutRoot
        result.withoutRoot = max(left.withRoot, left.withoutRoot) +
        max(right.withRoot, right.withoutRoot)
        return result
    }
    var robResult = helper(root)
    return max(robResult.withRoot, robResult.withoutRoot)
}


/*
 Given the root of a binary tree, return the most frequent subtree sum. If there is a tie, return all the values with the highest frequency in any order.

 The subtree sum of a node is defined as the sum of all the node values formed by the subtree rooted at that node (including the node itself).
 https://leetcode.com/problems/most-frequent-subtree-sum/description/
 */
/// Most Frequenct Subtree Sum
func findFrequentTreeSum(_ root: TreeNode?) -> [Int] {
    // Map<Sum, Frequency> while traverse the tree; after travers the tree
    // and generate the subtree sum for each node, return the most frequent sums
    // For find subtree sum:
    //  lChild: subtree sum of left subtree
    //  rChild: subree sum of right subtree
    //  root: root.val + lChild + rChild and add to map
    //  return root.val + lChild + rChild
    guard let root else { return [] }
    var map = [Int: Int]()
    func findSubtreeSum(_ root: TreeNode?) -> Int {
        guard let root else { return 0 }
        let leftSum = findSubtreeSum(root.left)
        let rightSum = findSubtreeSum(root.right)
        let currSubtreeSum = leftSum + rightSum + root.val
        map[currSubtreeSum, default: 0] += 1
        return currSubtreeSum
    }
    findSubtreeSum(root)
    let max = map.max { $0.value < $1.value}!.value
    return map.filter { $0.value == max }.map(\.key)
}


/*
 Given the root of a binary tree, return the leftmost value in the last row of the tree.
 https://leetcode.com/problems/find-bottom-left-tree-value/description/
 */
/// Find Bottom Left Tree Value
func findBottomLeftValue(_ root: TreeNode?) -> Int {
    // pass down the current level from 0 to bottom; with the inorder traversal
    // whenever we are able to update the leftmost leaf value; we have the situation
    // where the current level is exceeded the maxLevel we have traversed;
    guard let root else { return 0 }
    var (maxLevel, leftLeaf) = (-1, 0)
    func traverse(_ root: TreeNode?, _ currLevel: Int) {
        guard let root else { return }
        if currLevel > maxLevel {
            maxLevel = currLevel
            leftLeaf = root.val
        }
        traverse(root.left, currLevel + 1)
        traverse(root.right, currLevel + 1)
    }
    traverse(root, 0)
    return leftLeaf
}


/*
 Given the root node of a binary tree, your task is to create a string representation of the tree following a specific set of formatting rules. The representation should be based on a preorder traversal of the binary tree and must adhere to the following guidelines:

 Node Representation: Each node in the tree should be represented by its integer value.

 Parentheses for Children: If a node has at least one child (either left or right), its children should be represented inside parentheses. Specifically:

 If a node has a left child, the value of the left child should be enclosed in parentheses immediately following the node's value.
 If a node has a right child, the value of the right child should also be enclosed in parentheses. The parentheses for the right child should follow those of the left child.
 Omitting Empty Parentheses: Any empty parentheses pairs (i.e., ()) should be omitted from the final string representation of the tree, with one specific exception: when a node has a right child but no left child. In such cases, you must include an empty pair of parentheses to indicate the absence of the left child. This ensures that the one-to-one mapping between the string representation and the original binary tree structure is maintained.

 In summary, empty parentheses pairs should be omitted when a node has only a left child or no children. However, when a node has a right child but no left child, an empty pair of parentheses must precede the representation of the right child to reflect the tree's structure accurately.
 https://leetcode.com/problems/construct-string-from-binary-tree/description/
 Input: root = [1,2,3,4]
 Output: "1(2(4))(3)"
 Explanation: Originally, it needs to be "1(2(4)())(3()())", but you need to omit all the empty parenthesis pairs. And it will be "1(2(4))(3)".
 */
/// Construct String From Binary Tree
func tree2str(_ root: TreeNode?) -> String {
    // pre-order to traverse the tree;
    // for the current root(not leaf node), if leaf node, return value string
    // result string += root.value;
    // result string += leftVal
    // if contains right; += rightVal
    
    guard let root else { return "" }
    var result: String = "\(root.val)"
    if root.left == nil, root.right == nil { return result }
    let leftRes = tree2str(root.left)
    let rightRes = tree2str(root.right)
    result += "(" + leftRes + ")"
    if !rightRes.isEmpty {
        result += "(" + rightRes + ")"
    }
    return result
}


/*
 Given the root of a binary tree and two integers val and depth, add a row of nodes with value val at the given depth depth.

 Note that the root node is at depth 1.

 The adding rule is:

 Given the integer depth, for each not null tree node cur at the depth depth - 1, create two tree nodes with value val as cur's left subtree root and right subtree root.
 cur's original left subtree should be the left subtree of the new left subtree root.
 cur's original right subtree should be the right subtree of the new right subtree root.
 If depth == 1 that means there is no depth depth - 1 at all, then create a tree node with value val as the new root of the whole original tree, and the original tree is the new root's left subtree.
 https://leetcode.com/problems/add-one-row-to-tree/description/
 */
/// Add One Row to Tree
func addOneRow(_ root: TreeNode?, _ val: Int, _ depth: Int) -> TreeNode? {
    // dfs to traverse the tree, when moving down each level, pass down the current depth - 1 to next level
    // whenever the depth == 1, we reach the parent node where we need to create a new level;
    // then check if the upcoming direction is left or right; if left, then append the root's left
    // to new node's left, and if right, append the root's right to new node's right
    guard let root else { return TreeNode(val) }
    func helper(_ root: TreeNode?, _ val: Int, _ depth: Int, _ isLeft: Bool) -> TreeNode? {
        if depth == 1 {
            let newRoot = TreeNode(val)
            if isLeft {
                newRoot.left = root
            } else {
                newRoot.right = root
            }
            return newRoot
        } else {
            root?.left = helper(root?.left, val, depth - 1, true)
            root?.right = helper(root?.right, val, depth - 1, false)
            return root
        }
    }
    return helper(root, val, depth, true)
}


/*
 Given the root of a binary tree, construct a 0-indexed m x n string matrix res that represents a formatted layout of the tree. The formatted layout matrix should be constructed using the following rules:

 The height of the tree is height and the number of rows m should be equal to height + 1.
 The number of columns n should be equal to 2height+1 - 1.
 Place the root node in the middle of the top row (more formally, at location res[0][(n-1)/2]).
 For each node that has been placed in the matrix at position res[r][c], place its left child at res[r+1][c-2height-r-1] and its right child at res[r+1][c+2height-r-1].
 Continue this process until all the nodes in the tree have been placed.
 Any empty cells should contain the empty string "".
 Return the constructed matrix res.
 https://leetcode.com/problems/print-binary-tree/description/
 */

/// Print Binary Tree
func printTree(_ root: TreeNode?) -> [[String]] {
    guard let root else { return [] }
    let height = findHeight(root)
    let colCount = Int(pow(2.0, Double(height))) - 1
    var res: [[String]] = Array(repeating: Array(repeating: "", count: colCount), count: height)
    fillNodes(root, 0, colCount, 0)
    return res

    func fillNodes(_ root: TreeNode?, _ left: Int, _ right: Int, _ level: Int) {
        guard let root, left <= right else { return }
        let mid = left + (right - left) / 2
        res[level][mid] = "\(root.val)"
        fillNodes(root.left, left, mid - 1, level + 1)
        fillNodes(root.right, mid + 1, right, level + 1)
    }

    func findHeight(_ root: TreeNode?) -> Int {
        guard let root else { return 0 }
        let leftHeight = findHeight(root.left)
        let rightHeight = findHeight(root.right)
        return max(leftHeight, rightHeight) + 1
    }
}


/*
 Given the root of a binary tree, return the same tree where every subtree (of the given tree) not containing a 1 has been removed.

 A subtree of a node node is node plus every node that is a descendant of node.
 https://leetcode.com/problems/binary-tree-pruning/description/
 */
/// Binary Tree Pruning
func pruneTree(_ root: TreeNode?) -> TreeNode? {
    // lChild: pruned leftSubtree
    // rChild: pruned rightSubtree
    // self: check if self. is 1; is so, return self;
    //       else, if either left or right is not nil, return self
    guard let root else { return nil }
    root.left = pruneTree(root.left)
    root.right = pruneTree(root.right)
    if root.val == 0 && root.left == nil && root.right == nil{
        return nil
    } else {
        return root
    }
}


/*
 A complete binary tree is a binary tree in which every level, except possibly the last, is completely filled, and all nodes are as far left as possible.

 Design an algorithm to insert a new node to a complete binary tree keeping it complete after the insertion.

 Implement the CBTInserter class:

 CBTInserter(TreeNode root) Initializes the data structure with the root of the complete binary tree.
 int insert(int v) Inserts a TreeNode into the tree with value Node.val == val so that the tree remains complete, and returns the value of the parent of the inserted TreeNode.
 TreeNode get_root() Returns the root node of the tree.
 https://leetcode.com/problems/complete-binary-tree-inserter/description/
 */
class CBTInserter {
    // For each node, the parent is at the index where (queue.count - 1) / 2
    // Therefore, for initiation, we can simply use BFS to construct the queue
    // For insertion:
    //      use the (queue.count - 1) / 2 to find the parent index;
    //      then check if the count of queue is even or odd to append right or left
    private var nodeQueue: [TreeNode] = []
    init(_ root: TreeNode?) {
        guard let root else { return }
        nodeQueue.append(root)
        var currIndex = 0
        while currIndex < nodeQueue.count {
            let curr = nodeQueue[currIndex]
            if let left = curr.left {
                nodeQueue.append(left)
            }
            if let right = curr.right {
                nodeQueue.append(right)
            }
            currIndex += 1
        }
    }
    
    func insert(_ val: Int) -> Int {
        let newNode = TreeNode(val)
        let parentIndex = (nodeQueue.count - 1) / 2
        if nodeQueue.count % 2 == 0 {
            nodeQueue[parentIndex].right = newNode
        } else {
            nodeQueue[parentIndex].left = newNode
        }
        nodeQueue.append(newNode)
        return nodeQueue[parentIndex].val
    }
    
    func get_root() -> TreeNode? {
        return nodeQueue.first
    }
}

/*
 For a binary tree T, we can define a flip operation as follows: choose any node, and swap the left and right child subtrees.

 A binary tree X is flip equivalent to a binary tree Y if and only if we can make X equal to Y after some number of flip operations.

 Given the roots of two binary trees root1 and root2, return true if the two trees are flip equivalent or false otherwise.
 https://leetcode.com/problems/flip-equivalent-binary-trees/description/
 */

/// Flip Equivalent Binary Trees
func flipEquiv(_ root1: TreeNode?, _ root2: TreeNode?) -> Bool {
    switch (root1, root2) {
    case (.none, .none):
        return true
    case (.none, .some(_)), (.some(_), .none):
        return false
    case let (.some(r1), .some(r2)) where r1.val != r2.val:
        return false
    default:
        return (flipEquiv(root1?.left, root2?.left) && flipEquiv(root1?.right, root2?.right)) ||
        (flipEquiv(root1?.left, root2?.right) && flipEquiv(root1?.right, root2?.left))
    }
}

/*
 In a complete binary tree, every level, except possibly the last, is completely filled, and all nodes in the last level are as far left as possible. It can have between 1 and 2h nodes inclusive at the last level h.
 https://leetcode.com/problems/check-completeness-of-a-binary-tree/description/
 */
/// Check Completeness of a Binary Tree
func isCompleteTree(_ root: TreeNode?) -> Bool {
    // BFS to traverse the tree level by level; if there exist a bubble, we should be at the last
    // level, which means there should not be any more node generated
    guard let root else { return false }
    var queue = [root]
    var foundBubble = false
    while !queue.isEmpty {
        var curr = queue.removeFirst()
        if let left = curr.left {
            if foundBubble { return false }
            queue.append(left)
        } else {
            foundBubble = true
        }
        if let right = curr.right {
            if foundBubble { return false }
            queue.append(right)
        } else {
            foundBubble = true
        }
    }
    return true
}

/*
 Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

 Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.
 https://leetcode.com/problems/serialize-and-deserialize-binary-tree/description/
 */
class Codec {
    func serialize(_ root: TreeNode?) -> String {
        guard let root else { return "#" }
        return "\(root.val) \(serialize(root.left)) \(serialize(root.right))"
    }
    
    func deserialize(_ data: String) -> TreeNode? {
        let values = data.split(separator: " ")
        var index = 0
        func deserializeHelper() -> TreeNode? {
            guard index < values.count else { return nil }
            let value = String(values[index])
            index += 1
            if value == "#" {
                return nil
            }
            let root = TreeNode(Int(value)!)
            root.left = deserializeHelper()
            root.right = deserializeHelper()
            return root
        }
        return deserializeHelper()
    }
}


/*
 Given the root of a binary tree, return all duplicate subtrees.

 For each kind of duplicate subtrees, you only need to return the root node of any one of them.

 Two trees are duplicate if they have the same structure with the same node values.

 https://leetcode.com/problems/find-duplicate-subtrees/description/
 */
func findDuplicateSubtrees(_ root: TreeNode?) -> [TreeNode?] {
    // Maintain a map<String, Int> while traverse the tree with the order, left right self, so that
    // once we returned to a "root" node, we have received the subtree within it;
    // Time: O(n^2)
    // Space: O(n^2)
    var result = [TreeNode?]()
    var map = [String: Int]()

    // returned String represents the subtree as left, right self;
    func traverse(_ root: TreeNode?) -> String {
        guard let root else { return "#" }
        let leftSub = traverse(root.left)
        let rightSub = traverse(root.right)
        let curr = "\(root.val) \(leftSub) \(rightSub)"
        if let freq = map[curr], freq == 1 {
            result.append(root)
        }
        map[curr, default: 0] += 1

        return curr
    }

    traverse(root)
    return result
}

/*
 Given the root of a binary tree, calculate the vertical order traversal of the binary tree.

 For each node at position (row, col), its left and right children will be at positions (row + 1, col - 1) and (row + 1, col + 1) respectively. The root of the tree is at (0, 0).

 The vertical order traversal of a binary tree is a list of top-to-bottom orderings for each column index starting from the leftmost column and ending on the rightmost column. There may be multiple nodes in the same row and same column. In such a case, sort these nodes by their values.

 Return the vertical order traversal of the binary tree.
 https://leetcode.com/problems/vertical-order-traversal-of-a-binary-tree/description/
 */

/// Vertical Order Traversal of a Binary Tree
func verticalTraversal(_ root: TreeNode?) -> [[Int]] {
    // maintain map<Int, [(Int, Int)]> while traverse the tree;
    //  key: col index,
    //  value: (row, TreeNode val) -> need row index for sorting
    // therefore, when we traverse left, col index--, traverse right, col index++, to next level; row += 1
    //
    guard let root else { return [] }
    var map = [Int: [(Int, Int)]]()
    traverse(root, 0, 0)
    return map
    .sorted(by: { $0.key < $1.key })
    .map{ entry in
        entry.value.sorted {
            $0.0 < $1.0 || ($0.0 == $1.0 && $0.1 < $1.1)
        }.map {$0.1}
    }

    func traverse(_ root: TreeNode?, _ row: Int, _ col: Int) {
        guard let root else { return }
        map[col, default: []].append((row, root.val))
        traverse(root.left, row + 1, col - 1)
        traverse(root.right, row + 1, col + 1)
    }
}

/*
 Given the root of a binary tree with unique values and the values of two different nodes of the tree x and y, return true if the nodes corresponding to the values x and y in the tree are cousins, or false otherwise.

 Two nodes of a binary tree are cousins if they have the same depth with different parents.

 Note that in a binary tree, the root node is at the depth 0, and children of each depth k node are at the depth k + 1.
 https://leetcode.com/problems/cousins-in-binary-tree/description/
 */
func isCousins(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
    // Level by level traversal;
    // maintain 2 parent ref; whenever we generate the node that has the value equal to target;
    // set the corresponding parent ref; once we finished expanding current level;
    // if two parent ref are not nil and not the same, they are cousins
    // For each iteration:
    //  let size = queue.size
    //  var xPar: TreeNode?, yPar: TreeNode?
    //  for 0..<size
    //     curr = queue.removeFirst()
    //     if let left = currleft; if left.val == x || == y; xPar = curr || yPar = curr;
    //     if let right = currRight; if right.val == x || == y; xPar = curr || yPar = curr;
    //  if both xPar && yPar are not nil
    //      if xPar != yPar return true; else return false
    guard let root else { return false }
    var queue = [root]
    while !queue.isEmpty {
        let count = queue.count
        var matched = 0
        for _ in 0..<count {
            let curr = queue.removeFirst()
            if curr.val == x || curr.val == y {
                matched += 1
            }
            if let left = curr.left, let right = curr.right {
                if (left.val, right.val) == (x, y) || (left.val, right.val) == (y, x) {
                    return false
                }
            }
            if let left = curr.left {
                queue.append(left)
            }
            if let right = curr.right {
                queue.append(right)
            }
        }
        if matched == 2 {
            return true
        }
    }
    return false
}
