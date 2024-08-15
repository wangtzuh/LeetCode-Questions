import Foundation

// MARK: - LinkedList operations
/// Insert a new element at a specific index in the given linked list.
func insert(_ list: Node?, value: Int, at index: Int) -> Node? {
    if index < 0 { return list }
    if index == 0 {
        let newHead = Node(value)
        newHead.next = list
        return newHead
    }
    let newNode = Node(value)
    var curr = list
    var index = index
    while curr != nil, index - 1 > 0 {
        curr = curr!.next
        index -= 1
    }
    if curr == nil {
        return list
    }
    newNode.next = curr?.next
    curr?.next = newNode
    return list
}

var sorted = SampleCase.sorted(count: 10)
var shuffled = SampleCase.shuffled(count: 10)
insert(sorted, value: 11, at: 5)
insert(sorted, value: 222, at: 11)

/// Insert a value in a sorted linked list.
func insertInSorted(_ head: Node?, value: Int) -> Node {
    let newHead = Node(value)
    guard let head = head, head.value < value else {
        newHead.next = head
        return newHead
    }
    var curr = head
    while curr.next != nil && curr.value < value {
        curr = curr.next!
    }
    newHead.next = curr.next
    curr.next = newHead
    return head
}
sorted = SampleCase.sorted(count: 10)
insertInSorted(sorted, value: 2)
insertInSorted(sorted, value: 0)
insertInSorted(sorted, value: 10)

/// Delete the node at given index for linked list
func remove(_ head: Node?, at index: Int) -> Node? {
    guard index > 0 else { return head?.next }
    var curr = head
    var index = index
    while curr != nil && index > 1 {
        curr = curr?.next
        index -= 1
    }
    curr?.next = curr?.next?.next
    return head
}
sorted = SampleCase.sorted(count: 10)
remove(sorted, at: 3)

func remove(_ head: Node?, with value: Int) -> Node? {
    let dummy = Node(-1)
    var curr = dummy
    var head = head
    while head != nil {
        if head!.value != value {
            curr.next = head
            curr = curr.next!
        } else {
            curr.next = head!.next
        }
        head = head!.next
    }
    return dummy.next
}
sorted = SampleCase.sorted(count: 10)
insertInSorted(sorted, value: 4)
remove(sorted, with: 4)
remove(sorted, with: 2)

func removeNodes(_ head: Node?, indices: [Int]) -> Node? {
    let dummy = Node(-1)
    var curr = dummy
    var head = head
    var currIndex = 0
    var deleteCount = 0
    while head != nil && deleteCount < indices.count {
        if currIndex == indices[deleteCount] {
            curr.next = head?.next
            deleteCount += 1
        } else {
            curr.next = head
            curr = curr.next!
        }
        head = head?.next
        currIndex += 1
    }
    return dummy.next
}

sorted = SampleCase.sorted(count: 10)
removeNodes(sorted, indices: [0,2,3,6])

func reverse(_ node: Node?) -> Node? {
    var prev: Node? = nil
    var head = node
    while head != nil {
        let next = head!.next
        head!.next = prev
        prev = head
        head = next
    }
    return prev
}

func reverseR(_ node: Node?) -> Node? {
    if node == nil || node?.next == nil {
        return node
    }
    let newHead = reverseR(node?.next)
    node?.next?.next = node
    node?.next = nil
    return newHead
}

sorted = SampleCase.sorted(count: 10)

// 1     2    3 4 5 6 7
// H <- H.N | 3 4 5 6 7 |
// H.N = subproblem
// newHead = H.N
// return NewHead
/// Reserver the nodes in pairs for the linkedlist
func reverseInPairs(_ head: Node?) -> Node? {
    guard var head = head, let _ = head.next else { return head }
    let newNext = reverseInPairs(head.next?.next)
    let newHead = head.next
    head.next?.next = head
    head.next = newNext
    return newHead
}

sorted = SampleCase.sorted(count: 7)
reverseInPairs(sorted)

func merge(_ l1: Node?, _ l2: Node?) -> Node? {
    if l1 == nil { return l2 }
    if l2 == nil { return l1 }
    
    let dummy = Node(-1)
    var curr = dummy
    var l1 = l1, l2 = l2
    while l1 != nil && l2 != nil {
        if l1!.value <= l2!.value {
            curr.next = l1
            l1 = l1!.next
        } else {
            curr.next = l2
            l2 = l2!.next
        }
        curr = curr.next!
    }
    curr.next = l1 != nil ? l1:l2
    return dummy.next
}
sorted = SampleCase.sorted(count: 5)
var sorted2 = SampleCase.sorted(count: 5)
merge(sorted, sorted2)


/// Find the middle node for the given linked list
/// - Parameter node: The middle node
/// - Returns:
func findMidNode(_ node: Node?) -> Node? {
    guard var fast = node else { return node }
    var slow = fast
    while fast.next != nil, fast.next?.next != nil {
        slow = slow.next!
        fast = fast.next!.next!
    }
    return slow
}

findMidNode(sorted)

func removeDup(_ node: Node?) -> Node? {
    if node == nil { return node }
    let dummy = Node(-1)
    var curr = dummy
    var node = node
    while node != nil {
        while node?.next != nil && node!.next!.value == node!.value {
            node = node?.next
        }
        curr.next = node
        curr = curr.next!
        node = node?.next
    }
    return dummy.next
}

sorted = SampleCase.sorted(count: 10)
sorted2 = SampleCase.sorted(count: 11)
merge(sorted, sorted2)
removeDup(sorted2)

// 1 2 3 3 3 3 4 4 4 4 5
//   H N N+1
// For each step:
//   case 1: H.next = nil; append
//   case 2: H.next.v != H.v; append
//   case 3: H.next.v == H.v; keep iterate until H.n.v != h.v; move one

/// Remove all the duplicated nodes for the linked list
/// - Parameter node:
/// - Returns:
func removeAllDup(_ node: Node?) -> Node? {
    if node == nil { return nil }
    let dummy = Node(-1)
    var curr = dummy
    var head = node
    while head != nil {
        if head?.next == nil || head?.next?.value != head?.value { // case 1,2
            curr.next = head
            head = head?.next
            curr = curr.next!
            curr.next = nil
        } else { // case 3
            let currV = head!.value
            while head != nil && head!.value == currV { // terminate at the last dup element;
                head = head!.next
            }
        }
    }
    return dummy.next
}

sorted = SampleCase.fromArray([1,2,3,4,5,6,7,7,7,7])
removeAllDup(sorted)

// odd.next = odd.next(even).next
// even.next = even.next.next;
// odd = odd.next;
// even = even.next;
// odd.next = evenHead;

/// Re-arrange the given linked list into odd-even order
/// - Parameter node: Given linked list to be re-ordered
/// - Returns: Re-ordered linked list
func oddEvenList(_ node: Node?) -> Node? {
    if node == nil || node?.next == nil { return node }
    var odd = node
    var even = node?.next
    var evenHead = even
    while even != nil && even!.next != nil {
        odd?.next = odd?.next?.next
        odd = odd?.next
        even?.next = even?.next?.next
        even = even?.next
    }
    odd?.next = evenHead
    return node
}

sorted = SampleCase.sorted(count: 10)
oddEvenList(sorted)



/// Check if the given linked list is palindrome or not
/// - Parameter node:
/// - Returns:
func checkListIsPalindrome(_ node: Node?) -> Bool {
    guard var node = node else { return false }
    var midNode = findMidNode(node)?.next
    midNode = reverse(midNode)
    var curr = node
    while midNode != nil {
        if curr.value != midNode?.value {
            return false
        }
        curr = curr.next!
        midNode = midNode?.next
    }
    return true
}

sorted = SampleCase.fromArray([1,2,3,4,5,6,7])
var palindrom = SampleCase.fromArray([1,2,3,4,4,3,2,1])
findMidNode(SampleCase.fromArray([0,1,2,3,4,5]))
checkListIsPalindrome(sorted)
checkListIsPalindrome(palindrom)

// N1 -> N2 -> N3 -> N4 -> N5..
// N1 -> Nn -> N2 -> Nn-1 ...
// find mid node, then reverse the mid.next;
// merge two seperate node one by one;
func reorderLinkedList(_ node: Node?) -> Node? {
    if node == nil || node?.next == nil { return node }
    var midNode = findMidNode(node)
    var second = reverse(midNode?.next)
    midNode?.next = nil // disconnect the original midNode.next;
    var node = node
    
    let dummy = Node(-1)
    var curr = dummy
    while node != nil && second != nil {
        curr.next = node
        node = node?.next
        curr.next?.next = second
        second = second?.next
        curr = curr.next!.next!
    }
    curr.next = node
    
    return dummy.next
}

sorted = SampleCase.sorted(count: 10)
reorderLinkedList(sorted)

// N1 -> N2 -> N3 -> N4 -> N5
// N1 -> N3 -> N5 -> N4 -> N2
func reverseAlternate(_ node: Node?) -> Node? {
    if node == nil || node?.next == nil { return node }
    var currIndex = 0
    var curr = node
    let oddDummy = Node(-1), evenDummy = Node(-1)
    var odd: Node? = oddDummy, even: Node? = evenDummy
    while curr != nil {
        if currIndex % 2 == 0 {
            odd?.next = curr
            odd = odd?.next
        } else {
            even!.next = curr
            even = even?.next
        }
        curr = curr?.next
        currIndex += 1
    }
    even?.next = nil
    odd?.next = reverse(evenDummy.next)
    return oddDummy.next
}

sorted = SampleCase.sorted(count: 10)
reverseAlternate(sorted)

// MARK: - General Sorting Algorithm

func selectionSort() -> Node? {
    return nil
}
