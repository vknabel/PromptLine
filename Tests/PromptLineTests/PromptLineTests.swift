import XCTest
import Taps
import PromptLine

public func describePromptLine() -> Never {
  Taps.runMain(testing: [
    describePrefixPromptRunner,
    describeInfixPromptRunner,
    describeFlatMap,
    describeBashShell
  ])
}

public class PromptLineTapsTests: XCTestCase {
  public func testSomething() {
    describePromptLine()
  }
}
