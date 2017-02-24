public enum ShellCommand {
  case inlined(String)
  case prepared([String])
  case runner(PromptRunner<PromptError>)
}

public extension Prompt {
  public typealias Shell = (ShellCommand) -> PromptRunner<PromptError>
}

public extension Prompt {
  public static var bashShell: Shell {
    return { command in
      switch command {
      case let .inlined(cmd):
        #if os(Linux)
        return { $0.run(["bash", "-c", "cd \($0.workingDirectory) && \(cmd)"]) }
        #else
        return { $0.run(["bash", "-c", cmd]) }
        #endif
      case let .prepared(cmd):
        return { prompt in
          let envedCmd = cmd.map({ arg in
            prompt.environment.reduce(arg, { arg, envVar in
            arg.replacingOccurrences(of: "$\(envVar.key)", with: envVar.value)
            })
          })
          return prompt.run(envedCmd)
        }
      case let .runner(cmd):
        return cmd
      }
    }
  }
}
