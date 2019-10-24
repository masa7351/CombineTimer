# CombineTimer

SwiftUIでタイマー機能を簡単に実現するためのライブラリです。

## Requirements

- Xcode 11.0
- iOS 13.0

## Usage Guide

Setup Timer

```swift
@ObservedObject private var timer: CountDownTimer

// setup 60seconds timer 
init(timer: CountDownTimer = CountDownTimer(count: 60)) {
    self.timer = timer
}
```

※ コンストラクタで渡すcountは初期表示時の残時間としてお使いください。start時の引数で上書きされます。

start
```swift
self.timer.start(60)
```

resume
```swift
self.resume()
```

stop
```swift
self.stop()
```
※ stopを実行してもタイマーはリセットされません。

## Licence

MIT

## Author

[masa7351](https://github.com/masa7351)
