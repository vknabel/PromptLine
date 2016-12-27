
/// - Usage:
/// ```swift
/// extension ReporterFormat {
///   static var step = ReporterFormat(prefix: "👉")
///   static var success = ReporterFormat(prefix: "✅")
/// }
///
/// let reporter = report("Successfully done things", format: .success)
/// ```
public struct ReporterFormat {
  public var terminator: String
  public var format: ([String]) -> String
  
  public init(terminator: String = "\n", format: @escaping ([String]) -> String) {
    self.terminator = terminator
    self.format = format
  }
}

public extension ReporterFormat {
  public init(prefix: String, separator: String = " ", terminator: String = "\n") {
    self.terminator = terminator
    self.format = {
      $0.reduce(prefix, { $0 + separator + $1 })
    }
  }
  
  public static var raw = ReporterFormat(prefix: "")
}

public func report<E: Error>(_ items: CustomStringConvertible..., format: ReporterFormat) -> PromptRunner<E> {
  return { prompt in
    print(format.format(items.map({ $0.description })), terminator: format.terminator)
    return .success(prompt)
  }
}
