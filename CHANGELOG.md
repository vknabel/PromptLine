# PromptLine

## 0.6.0

### Further Changes

- Upgarded PathKit dependency

## 0.5.1

### Further Changes

- Fixes an issue, that prevented some env var from being executed

## 0.5.0

### Breaking Changes

- Reintroduced `TerminationReason` for `PromptError`
- Renamed infix `%` to infix `>-`

### API Additions

- Intoduces `Prompt.Shell` and `Prompt.defaultShell`, which is great for Unit Tests

### Further Changes

- Uses Taps for Unit Tests
- `>-(_:)` for `String` now executes in its own bash
- All operators are now lazy when creating closures
- Supports Linux by always using `.exit` as termination reason

## 0.4.0

### Further Changes

- Supports Linux - @vknabel

## 0.3.0

### API Additions

- Supports env vars - @vknabel

## 0.2.0

### Dependencies

- Includes `.git` for dependencies - @vknabel

### API Additions

- Temporarily change dir `Prompt.chdir(_:run:)` - @vknabel
- Added `ReporterFormat` for print runners - @vknabel

### Further Changes

- Added Xcodeproj in order to support Carthage - @vknabel

## 0.1.0

- Initial release - @vknabel
