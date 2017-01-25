import XCTest
import Taps
import PromptLine

public func describePromptLine() -> Never {
  Taps.runMain(testing: [
    describePrefixPromptRunner,
    describeInfixPromptRunner
  ])
}

public class PromptLineTapsTests: XCTestCase {
  func testSomething() {
    describePromptLine()
  }
}
