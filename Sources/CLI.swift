import ArgumentParser
import Logging

@main
struct CLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility for interacting with macOS via the terminal.",
        subcommands: [Toggle.self],
        defaultSubcommand: Toggle.self)
}

struct Options: ParsableArguments {
    @Flag(name: .shortAndLong, help: "Print debug information to stdout")
    var verbose = false
}

extension CLI {
    struct Toggle: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract:
                "Toggle an application (hide it if it's active; otherwise launch/activate it).")

        @Argument(help: "The Bundle ID of the Application.")
        var bundleId: String

        @OptionGroup var options: Options

        mutating func run() throws {
            print("Toggle command called: \(self)")

            var logger: Logger = Logger(label: "com.github.ccb012100.MacOSUtility.CLI")
            if options.verbose { logger.logLevel = .debug }

            toggleApp(withBundleId: bundleId, withLogger: logger)
        }
    }
}
