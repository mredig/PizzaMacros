import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros

let testMacros: [String: Macro.Type] = [
	"URL": URLMacro.self,
	"Data": DataBase64Macro.self,
]

final class PizzaMacrosTests: XCTestCase {
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

	func testDataBase64Macro() throws {
		assertMacroExpansion(
			#"""
			#Data(base64Encoded: "Zm9vYmFy")
			"""#,
			expandedSource: """
			Data(base64Encoded: "Zm9vYmFy")!
			""",
			macros: testMacros)
	}
}
#endif
