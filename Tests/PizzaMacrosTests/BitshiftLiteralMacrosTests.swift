import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(PizzaMacrosMacros)
import PizzaMacrosMacros


final class BitshiftLiteralMacrosTests: BaseTest {
	func testBitshiftMacro() throws {
		assertMacroExpansion(
			#"""
			let value = #Bitshift(1 << 0)
			let value2 = #Bitshift(1 << 1)
			let value3 = #Bitshift(1 << 4)
			"""#,
			expandedSource: """
			let value = 1
			let value2 = 2
			let value3 = 16
			""",
			macros: Self.testMacros)
	}
}
#endif
