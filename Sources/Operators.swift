import Result
import Foundation

precedencegroup PromptRunnerApplication {
  associativity: left
  higherThan: DefaultPrecedence
}

precedencegroup PromptRunnerThenChaining {
  associativity: left
  higherThan: PromptRunnerApplication
}

precedencegroup PromptRunnerOrChaining {
  associativity: left
  higherThan: PromptRunnerThenChaining
}

precedencegroup PromptRunnerAndChaining {
  associativity: left
  higherThan: PromptRunnerOrChaining
}

prefix operator >-
infix operator >- : PromptRunnerApplication
infix operator %& : PromptRunnerAndChaining
infix operator %| : PromptRunnerOrChaining
infix operator %> : PromptRunnerThenChaining
infix operator %? : PromptRunnerThenChaining

public typealias PromptRunner<E: Error> = (Prompt) -> Result<Prompt, E>

public let zeroRunner: PromptRunner<PromptError> = { .success($0) }

public func >- (prompt: Prompt, runner: PromptRunner<PromptError>) -> Result<Prompt, PromptError> {
  return runner(prompt)
}

public prefix func >- (arguments: [String]) -> PromptRunner<PromptError> {
  return Prompt.defaultShell(.prepared(arguments))
}

public prefix func >- (command: String) -> PromptRunner<PromptError> {
  return Prompt.defaultShell(.inlined(command))
}

public func flatMap<E: Error>(_ lhs: @escaping PromptRunner<E>, _ rhs: @autoclosure @escaping () -> PromptRunner<E>) -> PromptRunner<E> {
  return { prompt in
    let lr = lhs(prompt)
    switch lr {
    case let .success(env):
      return rhs()(env)
    case let .failure(env):
      return .failure(env)
    }
  }
}

public func %& <E: Error>(lhs: @escaping PromptRunner<E>, rhs: @autoclosure @escaping () -> PromptRunner<E>) -> PromptRunner<E> {
  return flatMap(lhs, rhs())
}

public func flatMapError<EL: Error, ER: Error>(_ lhs: @escaping PromptRunner<EL>, _ rhs: @autoclosure @escaping () -> PromptRunner<ER>) -> PromptRunner<ER> {
  return { prompt in
    let lr = lhs(prompt)
    switch lr {
    case let .success(env):
      return .success(env)
    case .failure(_):
      return rhs()(prompt)
    }
  }
}

public func %| <EL: Error, ER: Error>(lhs: @escaping PromptRunner<EL>, rhs: @autoclosure @escaping () -> PromptRunner<ER>) -> PromptRunner<ER> {
  return flatMapError(lhs, rhs())
}

public func second<EL: Error, ER: Error>(_ lhs: @escaping PromptRunner<EL>, _ rhs: @autoclosure @escaping () -> PromptRunner<ER>) -> PromptRunner<ER> {
  return { prompt in
    let lr = lhs(prompt)
    switch lr {
    case let .success(env):
      return rhs()(env)
    case .failure(_):
      return rhs()(prompt)
    }
  }
}

public func %> <EL: Error, ER: Error>(lhs: @escaping PromptRunner<EL>, rhs: @autoclosure @escaping () -> PromptRunner<ER>) -> PromptRunner<ER> {
  return second(lhs, rhs())
}

public func mapError<EL: Error, ER: Error>(_ lhs: @escaping PromptRunner<EL>, transform rhs: @escaping (EL) -> ER) -> PromptRunner<ER> {
  return { prompt in
    let lr = lhs(prompt)
    switch lr {
    case let .success(env):
      return .success(env)
    case let .failure(error):
      return .failure(rhs(error))
    }
  }
}

public func %? <EL: Error, ER: Error>(lhs: @escaping PromptRunner<EL>, rhs: @escaping (EL) -> ER) -> PromptRunner<ER> {
  return mapError(lhs, transform: rhs)
}
