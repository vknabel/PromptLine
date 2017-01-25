import Taps
import Result
@testable import PromptLine

func describeInfixPromptRunner(taps: Taps) {
  taps.rx.shellRunnerTest(
    "infix >- produces result",
    plan: 1,
    running: { $0 >- >-"" }
  ) { t, creations, _, _ in
    creations.single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "infix >- executes runners",
    plan: 1,
    running: { $0 >- >-"" }
  ) { t, _, executions, _ in
    executions.single()
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "infix >- succeeding runners succeed",
    plan: 1,
    running: { $0 >- >-"" }
  ) { t, _, _, results in
    results.single()
      .map { $0.value }
      .test(onNext: t.ok())
  }

  taps.rx.shellRunnerTest(
    "infix >- failing runners fail",
    plan: 1,
    running: { $0 >- { _ in .failure(.termination(status: 1, reason: .exit)) } }
  ) { t, _, _, results in
    results.single()
      .map(Result.dematerialize)
      .test(onError: t.doesThrow(of: PromptError.self))
  }
}
