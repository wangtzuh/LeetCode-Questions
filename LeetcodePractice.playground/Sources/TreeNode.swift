import Foundation

public class TreeNode {
    public var value: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public var parent: TreeNode?
    
    public init(value: Int) {
        self.value = value
    }
}

public extension TreeNode {
    static func create(from array: [Int?]) -> TreeNode? {
        guard array.count > 0 else { return nil }
        var index = 0
        let root = TreeNode(value: array[index]!)
        index += 1
        var queue: [TreeNode] = [root]
        while index < array.count {
            let currNode = queue.removeFirst()
            if index < array.count, let leftValue = array[index] {
                currNode.left = TreeNode(value: leftValue)
                queue.append(currNode.left!)
            }
            index += 1
            if index < array.count, let rightValue = array[index] {
                currNode.right = TreeNode(value: rightValue)
                queue.append(currNode.right!)
            }
            index += 1
        }
        return root
    }
}
