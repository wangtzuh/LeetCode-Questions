import Foundation

/// Basic Queue implementation using Array;
public struct SimpleQueue<T> {
    
    private var buffer: [T]
    private var maxLen: Int
    
    public init(len: Int) {
        self.maxLen = len
        self.buffer = [T]()
    }
    
    public var isEmpty: Bool {
        buffer.isEmpty
    }
    
    public var peek: T? {
        buffer.first
    }
    
    public mutating func enqueue(_ newValue: T) -> Bool {
        if (buffer.count < maxLen) {
            buffer.append(newValue)
            return true
        }
        return false
    }
    
    public mutating func dequeue() -> T? {
        isEmpty ? nil : buffer.removeFirst()
    }
}

extension SimpleQueue: CustomDebugStringConvertible {
    public var debugDescription: String {
        return buffer.map({"\($0)"}).joined(separator: "->")
    }
}

struct RingBufferQueueOptional<T> {
    private var buffer: [T?]
    private var maxLen: Int
    private var front = -1
    private var end = -1
    
    init(maxLen: Int) {
        self.buffer = Array(repeating: nil, count: maxLen)
        self.maxLen = maxLen
    }
    
    var isEmpty: Bool {
        front == -1 && end == -1
    }
    
    var isFull: Bool {
        (end + 1) % maxLen == front
    }
    
    var peek: T? {
        if isEmpty { return nil }
        return buffer[front]
    }
}

extension RingBufferQueueOptional {
    mutating func enqueue(_ newValue: T) -> Bool {
        guard !isFull else { return false }
        
        if front == -1 && end == -1 {
            front += 1
        }
        end = (end + 1) % maxLen
        buffer[end] = newValue
        return true
    }
    
    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        if front == end {
            defer {
                buffer[front] = nil
                front -= 1
                end -= 1
            }
            return buffer[front]
        }
        
        defer {
            buffer[front] = nil
            front = (front + 1) % maxLen
        }
        return buffer[front]
    }
}

extension RingBufferQueueOptional: CustomDebugStringConvertible {
    var debugDescription: String {
        buffer.map({ "\(String(describing: $0))"}).joined(separator: "->")
    }
}


struct RingBufferQueue<T> {
    private var buffer: [T]
    private var maxLen: Int
    private var front = -1
    private var end = -1
    
    init(maxLen: Int) {
        self.buffer = [T]()
        self.maxLen = maxLen
    }
    
    var isEmpty: Bool {
        front == -1 && end == -1
    }
    
    var isFull: Bool {
        (end + 1) % maxLen == front
    }
    
    var peek: T? {
        if isEmpty { return nil }
        return buffer[front]
    }
}

extension RingBufferQueue {
    mutating func enqueue(_ newValue: T) -> Bool {
        guard !isFull else { return false }
        
        if front == -1 && end == -1 {
            front += 1
        }
        end = (end + 1) % maxLen
        if (buffer.count < end) {
            buffer.append(newValue)
        } else {
            buffer[end] = newValue
        }
        return true
    }
    
    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        if front == end {
            defer {
                front -= 1
                end -= 1
            }
            return buffer[front]
        }
        
        defer {
            front = (front + 1) % maxLen
        }
        return buffer[front]
    }
}

extension RingBufferQueue: CustomDebugStringConvertible {
    var debugDescription: String {
        buffer.map({ "\(String(describing: $0))"}).joined(separator: "->")
    }
}

