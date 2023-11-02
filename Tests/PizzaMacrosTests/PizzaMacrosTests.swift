import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros

let testMacros: [String: Macro.Type] = [
	"stringify": StringifyMacro.self,
	"URL": URLMacro.self,
]

final class PizzaMacrosTests: XCTestCase {
    func testMacro() throws {
        #if canImport(PizzaMacrosMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(PizzaMacrosMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

	func testURLMacro() throws {
		assertMacroExpansion(
			#"""
			#URL("https://google.com")
			"""#,
			expandedSource: """
			URL(string: "https://google.com")!
			""",
			macros: testMacros)
	}
}
#endif
