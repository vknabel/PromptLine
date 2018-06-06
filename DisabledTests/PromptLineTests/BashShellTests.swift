import Taps
import Result
@testable import PromptLine

func describeBashShell(taps: Taps) {
  taps.rx.shellRunnerTest(
    "bash shell fails on inlined error",
    plan: 1,
    timeout: 0.1,
    running: >-"exit 1",
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { $0.error != nil }))
  }

  taps.rx.shellRunnerTest(
    "bash shell keeps inlined exit code",
    plan: 1,
    timeout: 0.1,
    running: >-"exit 42",
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { promptError in
        if case .some(.termination(status: 42, reason: .exit)) = promptError.error {
          return true
        } else {
          return false
        }
      }))
  }

  taps.rx.shellRunnerTest(
    "bash shell fails on prepared error",
    plan: 1,
    timeout: 0.1,
    running: >-["bash", "-c", "exit 1"],
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { $0.error != nil }))
  }

  taps.rx.shellRunnerTest(
    "bash shell keeps prepared exit code",
    plan: 1,
    timeout: 0.1,
    running: >-["bash", "-c", "exit 42"],
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { promptError in
        if case .some(.termination(status: 42, reason: .exit)) = promptError.error {
          return true
        } else {
          return false
        }
      }))
  }

  taps.rx.shellRunnerTest(
    "bash shell fails on prepared error",
    plan: 1,
    timeout: 0.1,
    running: failingPromptRunner,
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { $0.error != nil }))
  }

  taps.rx.shellRunnerTest(
    "bash shell keeps prepared exit code",
    plan: 1,
    timeout: 0.1,
    running: exitPromptRunner(with: 42),
    shell: Prompt.bashShell
  ) { t, _, _, results in
    results.single()
      .test(onNext: t.ok(matches: { promptError in
        if case .some(.termination(status: 42, reason: .exit)) = promptError.error {
          return true
        } else {
          return false
        }
      }))
  }
}
