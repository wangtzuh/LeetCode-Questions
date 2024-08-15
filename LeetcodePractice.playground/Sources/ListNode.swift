import Foundation

// MARK: - Node struct + Sample LinkedList generation
public class Node {
    public let value: Int
    public var next: Node?
    public init(_ value: Int) {
        self.value = value
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        var des = "\(self.value)"
        var curr = self
        while let next = curr.next {
            des.append("->\(next.value)")
            curr = next
        }
        return des
    }
}

public class SampleCase {
    public static func sorted(count: Int) -> Node {
        let head = Node(0)
        var curr = head
        for i in 1..<count {
            curr.next = Node(i)
            curr = curr.next!
        }
        return head
    }
    
    public static func shuffled(count: Int) -> Node {
        let sequence = 0..<count
        let shuffled = sequence.shuffled()
        let head = Node(shuffled[0])
        var curr = head
        for i in 1..<shuffled.count {
            curr.next = Node(shuffled[i])
            curr = curr.next!
        }

        return head
    }
    
    public static func fromArray(_ input: [Int]) -> Node {
        let dummy = Node(-1)
        var curr = dummy
        for num in input {
            curr.next = Node(num)
            curr = curr.next!
        }
        return dummy.next!
    }
}
