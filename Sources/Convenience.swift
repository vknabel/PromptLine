import PathKit
import Result
import Foundation

public extension Prompt {
  public static func mkpath(_ path: Path) -> PromptRunner<PromptError> {
    return { prompt in Result<Prompt, AnyError>(attempt: {
      try (prompt.workingDirectory + path).mkpath()
      return prompt
    })
      .mapError({ _ in PromptError.termination(status: 1)})
    }
  }

  public static func chdir<E: Error>(_ path: Path, run runner: @escaping PromptRunner<E>) -> PromptRunner<E> {
    return { prompt in
      let oldPath = prompt.workingDirectory
      let wrapped = Prompt.cd(path)
        %& runner
        %& { .success($0.lensWorkingDirectory(to: oldPath)) }
      return wrapped(prompt)
    }
  }
}

public extension Prompt {
    public static func cd<E: Error>(_ path: Path) -> PromptRunner<E> {
        return { p in
            .success(p.lensWorkingDirectory(to: p.workingDirectory + path))
        }
    }
    
    public func declare(_ variable: String, as value: String) -> Prompt {
        var env = environment
        env[variable] = value
        return lensEnvironment(to: env)
    }
}
