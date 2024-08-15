import Foundation

public protocol Queue {
    associatedtype DataType: Comparable
    
    /// Insert a new item into the queue
    /// - Parameter item: The item to be added.
    /// - Returns: Whether or not the insertion is successful.
    @discardableResult func add(_ item: DataType) -> Bool
    
    /// Removes the first item in line
    /// - Returns: The removed item
    /// - Throws: An error of `QueueError`
    @discardableResult func remove() throws -> DataType
    
    
    /// Gets the first itme on queue and remove it from queue.
    /// - Returns: An Optional conataining the first item in the queue.
    func dequeue() -> DataType?
    
    /// Gets the first item on queue, without removing it from queue.
    /// - Returns: An Optional containing the first item in the queue.
    func peek() -> DataType?
    
    /// Clear the queue
    func clear() -> Void
}

public enum QueueError: Error {
    case noSuchItem(String)
}

public class PriorityQueue<T: Comparable> {
    private var queue: Array<T>
    
    public var size: Int {
        return queue.count
    }
    
    public init() {
        self.queue = Array<T>()
    }
}

extension PriorityQueue: Queue {
    public typealias DataType = T
    public func add(_ item: DataType) -> Bool {
        self.queue.append(item)
        self.heapifyUp(from: self.queue.count - 1)
        return true
    }
    
    public func remove() throws -> DataType {
        guard queue.count > 0 else {
            throw QueueError.noSuchItem("Attempt to remove item from an empty queue.")
        }
        return self.popAndHeapifyDown()
    }
    
    public func dequeue() -> DataType? {
        guard queue.count > 0 else { return nil }
        return popAndHeapifyDown()
    }
    
    public func peek() -> DataType? {
        return queue.first
    }
    
    public func clear() {
        queue.removeAll()
    }
    
    private func popAndHeapifyDown() -> DataType {
        let firstItem = queue[0]
        if self.queue.count == 1 {
            queue.remove(at: 0)
            return firstItem
        }
        
        queue[0] = queue.remove(at: queue.count - 1)
        heapifyDown()
        return firstItem
    }
    
    private func heapifyUp(from index: Int) {
        var child = index
        var parent = child.parent
        
        while parent >= 0 && queue[parent] > queue[child] {
            swap(parent, with: child)
            child = parent
            parent = child.parent
        }
    }
    
    private func heapifyDown() {
        var parent = 0
        while true {
            let leftChild = parent.leftChild
            if leftChild >= queue.count {
                break
            }
            
            let rightChild = parent.rightChild
            var minChild = leftChild
            if rightChild < queue.count && queue[minChild] > queue[rightChild] {
                minChild = rightChild
            }
            
            if queue[parent] > queue[minChild] {
                swap(parent, with: minChild)
                parent = minChild
            } else {
                break
            }
        }
    }
    
    /// Swap the items located at two different indices in out backing storage
    /// - Parameters:
    ///   - firstIndex: The index of the first item being swapped
    ///   - secondIndex: The index of the second item being swapped
    private func swap(_ firstIndex: Int, with secondIndex: Int) {
        let firstItem = queue[firstIndex]
        queue[firstIndex] = queue[secondIndex]
        queue[secondIndex] = firstItem
    }
}

extension PriorityQueue: CustomStringConvertible {
    public var description: String {
        return queue.description
    }
}

private extension Int {
    var leftChild: Int {
        return (2 * self) + 1
    }
    
    var rightChild: Int {
        return (2 * self) + 2
    }
    
    var parent: Int {
        return (self - 1) / 2
    }
}
