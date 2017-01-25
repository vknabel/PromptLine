import Taps
import Result
import PromptLine
import RxSwift

struct OneError: Error { }
struct AnotherError: Error { }

extension Prompt {
  static var emptyShell: Shell {
    return { command in
      guard case let .runner(runner) = command else { return Result.success }
      return runner
    }
  }

  fileprivate static func testing(
    shell: (@escaping Shell),
    onCreation creation: AnyObserver<ShellCommand>,
    onExecution execution: AnyObserver<Prompt>,
    onResult result: AnyObserver<Result<Prompt, PromptError>>
  ) -> Shell {
    return { command in
      creation.onNext(command)
      return { prompt in
        let toBeExecuted = shell(command)
        execution.onNext(prompt)
        let executionResult = toBeExecuted(prompt)
        result.onNext(executionResult)
        return executionResult
      }
    }
  }
}

typealias ShellTester<T> = (
  OfferingTests,
  Observable<ShellCommand>,
  Observable<Prompt>,
  Observable<Result<Prompt, PromptError>>
) -> Observable<T>

extension OfferingRxTaps {
  func shellRunnerTest<T>(
    _ title: String? = nil,
    plan: Int? = nil,
    file: String = #file,
    line: Int = #line,
    column: Int = #column,
    function: String = #function,
    timeout interval: RxTimeInterval? = nil,
    scheduler: SchedulerType? = nil,
    prompt: Prompt = Prompt(),
    running runner: @autoclosure @escaping () -> PromptRunner<PromptError>,
    shell: @escaping Prompt.Shell = Prompt.emptyShell,
    with testShell: @escaping ShellTester<T>
  ) {
    let location = SourceLocation(file: file, line: line, column: column, function: function)
    let creations = ReplaySubject<ShellCommand>.createUnbounded()
    let executions = ReplaySubject<Prompt>.createUnbounded()
    let results = ReplaySubject<Result<Prompt, PromptError>>.createUnbounded()
    let testingShell = Prompt.testing(
      shell: shell,
      onCreation: creations.asObserver(),
      onExecution: executions.asObserver(),
      onResult: results.asObserver()
    )
    self.genericTest(
      title,
      source: location,
      timeout: interval,
      scheduler: scheduler
    ) { t -> Observable<T> in
      defer {
        let oldDefault = Prompt.defaultShell
        defer { Prompt.defaultShell = oldDefault }

        Prompt.defaultShell = testingShell
        results.onNext(runner()(prompt))
        creations.onCompleted()
        executions.onCompleted()
        results.onCompleted()
      }
      if let plan = plan {
        return testShell(
          t,
          creations.take(plan),
          executions.take(plan),
          results.take(plan)
        )
      } else {
        return testShell(
          t,
          creations.asObservable(),
          executions.asObservable(),
          results.asObservable()
        )
      }
    }
  }
}
