import Combine
import SwiftUI

struct CombineTimer {
    var text = "Hello, World!"
}

public final class CountDownTimer: ObservableObject {
    // MARK: - Input

    public var start: (Int) -> Void
    public var resume: () -> Void
    public var stop: () -> Void
    
    // MARK: - Output

    @Published public private(set) var count: Int
    @Published public private(set) var isRunning: Bool
    @Published public private(set) var isFinish: Bool
    public var hasTime: Bool {
        return count > 0
    }

    // MARK: - Property
    
    private var cancelableObjects: [AnyCancellable] = []
    private var timer: Cancellable? = nil
    
    public init(count: Int) {
        self.count = count
        self.isRunning = false
        self.isFinish = false
        
        let _start = PassthroughSubject<Int, Never>()
        start = { _start.send($0) }

        let _resume = PassthroughSubject<Void, Never>()
        resume = { _resume.send() }

        let _stop = PassthroughSubject<Void, Never>()
        stop = { _stop.send() }

        _start.sink { time in
            self.isRunning = true
            self.count = time
            self.timer = Timer.publish(every: 1.0, on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    self.count.decrement()
                }
        }.store(in: &cancelableObjects)

        _resume.sink { _ in
            self.isRunning = true
            self.timer = Timer.publish(every: 1.0, on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    self.count.decrement()
                }
        }.store(in: &cancelableObjects)
        
        _stop.sink { _ in
            self.isRunning = false
            self.timer?.cancel()
        }.store(in: &cancelableObjects)
        
        $count
            .removeDuplicates()
            .map { $0 == 0 }
            .assign(to: \.isFinish, on: self)
            .store(in: &cancelableObjects)
    }
    
    deinit {
        timer?.cancel()
        cancelableObjects.forEach { $0.cancel() }
    }
}

private extension Int {
    mutating func decrement() {
        if self <= 0 {
            self = 0
        } else {
            self -= 1
        }
    }
}
