import Foundation
import PathKit
import Lens

#if os(Linux) || swift(>=4.1)
typealias Process = Task
#endif

public struct Prompt {
  public static var defaultShell = bashShell

  public let launch: Path
  public let workingDirectory: Path
  public let environment: [String: String]

  public static var current: Prompt {
    return Prompt()
  }

  public init(
    launch: Path = "/usr/bin/env",
    workingDirectory: Path = Path.current,
    environment: [String: String] = ProcessInfo.processInfo.environment
  ) {
    self.launch = launch
    self.workingDirectory = workingDirectory
    self.environment = environment
  }
}

public extension Prompt {
  public static var workingDirectory: Lens<Prompt, Path> {
    return Lens(
      from: { $0.workingDirectory },
      to: { Prompt(workingDirectory: $0.0, environment: $0.1.environment) }
    )
  }

  public func lensWorkingDirectory(to path: Path) -> Prompt {
    return Prompt.workingDirectory.to(path, self)
  }

  public static var environment: Lens<Prompt, [String: String]> {
    return Lens(
      from: { $0.environment },
      to: { Prompt(workingDirectory: $0.1.workingDirectory, environment: $0.0) }
    )
  }

  public func lensEnvironment(to environment: [String: String]) -> Prompt {
    return Prompt.environment.to(environment, self)
  }
}

import Result

public enum PromptError: Error {
  case termination(status: Int, reason: Process.TerminationReason)
}

public extension Prompt {
  public func run(_ arguments: String...) -> Result<Prompt, PromptError> {
    return run(arguments)
  }
  public func run(_ arguments: [String]) -> Result<Prompt, PromptError> {
    let process = Process()
    process.launchPath = launch.description
    process.arguments = arguments
    process.currentDirectoryPath = workingDirectory.description
    process.environment = environment
    process.launch()
    process.waitUntilExit()

    let status = Int(process.terminationStatus)
    #if os(Linux)
    if status == 0 {
      return Result.success(self)
    } else {
      return .failure(PromptError.termination(status: status, reason: .exit))
    }
    #else
    if process.terminationReason == .exit && status == 0 {
      return Result.success(self)
    } else {
      return .failure(PromptError.termination(status: status, reason: process.terminationReason))
    }
    #endif
  }
}
