import Taps
import Result
@testable import PromptLine

func describePrefixPromptRunner(taps: OfferingTaps) {
  taps.rx.shellRunnerTest(
    "prefix >- for strings creates runner",
    plan: 1,
    running: >-""
  ) { t, creations, _, _ in
    creations.single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "prefix >- for string arrays creates runner",
    plan: 1,
    running: >-[""]
  ) { t, creations, _, _ in
    creations.single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "prefix >- for string arrays creates runner",
    plan: 1,
    running: >-[""]
  ) { t, creations, _, _ in
    creations.single()
      .test(onNext: t.ok())
  }
}
