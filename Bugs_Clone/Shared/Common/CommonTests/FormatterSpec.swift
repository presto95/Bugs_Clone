//
//  FormatterSpec.swift
//  CommonTests
//
//  Created by Presto on 2021/08/16.
//

import Quick
import Nimble
@testable import Common

final class FormatterSpec: QuickSpec {
    override func spec() {
        describe("duration") {
            context("int: 0") {
                it("00:00") {
                    expect(Formatter.durationToString(0)) == "00:00"
                }
            }

            context("int: 1") {
                it("00:01") {
                    expect(Formatter.durationToString(1)) == "00:01"
                }
            }

            context("int: 59") {
                it("00:59") {
                    expect(Formatter.durationToString(59)) == "00:59"
                }
            }

            context("int: 60") {
                it("01:00") {
                    expect(Formatter.durationToString(60)) == "01:00"
                }
            }

            context("timeInterval: 0") {
                it("00:00") {
                    expect(Formatter.durationToString(TimeInterval(0))) == "00:00"
                }
            }

            context("timeInterval: 1") {
                it("00:01") {
                    expect(Formatter.durationToString(TimeInterval(1))) == "00:01"
                }
            }

            context("timeInterval: 59") {
                it("00:59") {
                    expect(Formatter.durationToString(TimeInterval(59))) == "00:59"
                }
            }

            context("timeInterval: 60") {
                it("01:00") {
                    expect(Formatter.durationToString(TimeInterval(60))) == "01:00"
                }
            }
        }
    }
}

