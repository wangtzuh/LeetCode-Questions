import Foundation

func fibonacci(_ k: Int, _ recursive: Bool) -> Int {
    if recursive {
        if k == 0 { return 0 }
        if k == 1 { return 1 }
        return fibonacci(k - 1, true) + fibonacci(k - 2, true)
    } else {
        var prevPrev = 0
        var prev = 1
        var curr = 0
        for i in 2...k {
            curr = prevPrev + prev
            prevPrev = prev
            prev = curr
        }
        return curr
    }
}

func power(a: Int, b: Int) -> Int {
    if b == 0 { return 1 }
    if a == 0 { return 0 }
    
    var half = power(a: a, b: b / 2)
    if b % 2 == 0 {
        return half * half
    } else {
        return half * half * a
    }
}
