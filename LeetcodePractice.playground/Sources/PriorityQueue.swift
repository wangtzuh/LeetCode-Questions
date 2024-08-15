import Foundation

public struct PriorityQueueEasy<Element: Hashable> {
    private var elements: [Element] = []
    private let sorting: (Element, Element) -> Bool
    
    public init(sorting: @escaping (Element, Element) -> Bool) {
        self.sorting = sorting
    }
    
    public mutating func enqueue(_ newValue: Element) {
        elements.append(newValue)
        elements.sort(by: sorting)
    }
    
    public mutating func dequeue() -> Element? {
        return elements.isEmpty ? nil : elements.removeFirst()
    }
    
    public var isEmpty: Bool {
        elements.isEmpty
    }
}
