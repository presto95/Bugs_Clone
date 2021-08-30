//
//  Seekbar.swift
//  MusicPlayerUI_SwiftUI
//
//  Created by Presto on 2021/08/15.
//

import SwiftUI

struct Seekbar: View {
    @State private var isTracking: Bool = false
    @Binding private var currentTime: TimeInterval?
    @Binding private var endTime: TimeInterval?

    private var timeUpdatedWithSeekingAction: ((TimeInterval) -> Void)?

    init(currentTime: Binding<TimeInterval?>, endTime: Binding<TimeInterval?>) {
        self._currentTime = currentTime
        self._endTime = endTime
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                entireTimeBar(geometryProxy: proxy)

                currentTimeBar(geometryProxy: proxy)
                        .frame(width: {
                            if timeRatio == .zero {
                                return 0
                            } else {
                                return proxy.size.width * CGFloat(timeRatio)
                            }
                        }())
            }
        }
    }
}

extension Seekbar {
    func timeUpdatedWithSeekingAction(_ action: @escaping (TimeInterval) -> Void) -> Self {
        var `self` = self
        self.timeUpdatedWithSeekingAction = action
        return self
    }
}

private extension Seekbar {
    func entireTimeBar(geometryProxy: GeometryProxy) -> some View {
        Rectangle()
            .foregroundColor(.gray)
            .gesture(tapGesture(geometryProxy: geometryProxy))
            .gesture(dragGesture(geometryProxy: geometryProxy))
            .gesture(longPressGesture(geometryProxy: geometryProxy))
    }

    func currentTimeBar(geometryProxy: GeometryProxy) -> some View {
        Rectangle()
            .foregroundColor(.black)
            .gesture(tapGesture(geometryProxy: geometryProxy))
            .gesture(dragGesture(geometryProxy: geometryProxy))
            .gesture(longPressGesture(geometryProxy: geometryProxy))
    }
}

private extension Seekbar {
    func tapGesture(geometryProxy: GeometryProxy) -> some Gesture {
        TapGesture()
            .onEnded {
                isTracking = false
            }
    }

    func dragGesture(geometryProxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                isTracking = true

                let location = value.location
                currentTime = {
                    if let endTime = endTime, endTime != .zero {
                        return Double(location.x / geometryProxy.size.width) * endTime
                    } else {
                        return 0
                    }
                }()
            }
            .onEnded { value in
                isTracking = false
            }
    }

    func longPressGesture(geometryProxy: GeometryProxy) -> some Gesture {
        LongPressGesture(minimumDuration: 0.1)
            .onChanged { value in
                isTracking = true
            }
            .onEnded { value in
                isTracking = false
            }
    }

    var timeRatio: Double {
        if let endTime = endTime, endTime != .zero {
            let currentTime = currentTime ?? .zero
            return currentTime / endTime
        } else {
            return 0
        }
    }
}

// MARK: - Preview

struct Seekbar_Previews: PreviewProvider {
    static var previews: some View {
        Seekbar(currentTime: .constant(10), endTime: .constant(12))
            .frame(width: UIScreen.main.bounds.width, height: 8)
    }
}
