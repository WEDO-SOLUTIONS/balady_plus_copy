extension Timer {
    static func everyMinuteStart(
        block: @escaping @Sendable (Timer) -> Void
    )
        -> Timer
    {
        let now = Date()
        
        let nextMinute = Calendar.current.nextDate(
            after: now,
            matching: DateComponents(second: 0),
            matchingPolicy: .nextTime)!

        let minute = TimeInterval(60)

        let timer = Timer(
            fire: nextMinute, interval: minute, repeats: true, block: block
        )

        RunLoop.main.add(timer, forMode: .default)
        
        return timer
    }
}
