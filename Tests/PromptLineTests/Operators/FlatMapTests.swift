import Taps
import Result
@testable import PromptLine

func describeFlatMap(taps: Taps) {
  taps.rx.shellRunnerTest(
    "flat map creates both on success",
    plan: 2,
    running: >-"" %& >-""
  ) { t, creations, _, _ in
    creations
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "flat map creates only one on error",
    plan: 1,
    running: failingPromptRunner %& >-""
  ) { t, creations, _, _ in
    creations
      .skip(1)
      .test(
        onNext: t.fail(),
        onCompleted: t.ok()
      )
  }

  taps.rx.shellRunnerTest(
    "flat map executes both on success",
    plan: 2,
    running: >-"" %& >-""
  ) { t, creations, _, _ in
    creations
      .skip(1)
      .single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "flat map executes only one on error",
    plan: 1,
    running: failingPromptRunner %& >-""
  ) { t, _, executions, _ in
    executions
      .single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "flat map executes only one on error",
    plan: 1,
    running: failingPromptRunner %& >-""
  ) { t, _, executions, _ in
    executions
      .single()
      .test(onNext: t.ok())
  }
}
