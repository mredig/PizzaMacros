import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros


final class Base64Tests: BaseTest {
	func testDataBase64Macro() throws {
		assertMacroExpansion(
			#"""
			#Data(base64Encoded: "Zm9vYmFy")
			"""#,
			expandedSource: """
			Data(base64Encoded: "Zm9vYmFy")!
			""",
			macros: Self.testMacros)
	}

	func testStringBase64Macro() throws {
		assertMacroExpansion(
			#"""
			#String(base64Encoded: "Zm9vYmFy")
			"""#,
			expandedSource: """
			String(data: Data(base64Encoded: "Zm9vYmFy")!, encoding: .utf8)!
			""",
			macros: Self.testMacros)
	}
}
#endif
