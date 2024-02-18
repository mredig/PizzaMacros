import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public enum StringBase64Macro: ExpressionMacro {
	public static func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in context: some MacroExpansionContext
	) throws -> ExprSyntax {
		guard
			let b64Argument = node.argumentList.first?.expression,
			let segments = b64Argument.as(StringLiteralExprSyntax.self)?.segments,
			segments.count == 1,
			case .stringSegment(let literalSegment)? = segments.first
		else {
			throw MacroError.message("#String(base64Encoded:) requires a static string literal")
		}

		guard
			let data = Data(base64Encoded: literalSegment.content.text),
			String(data: data, encoding: .utf8) != nil
		else { throw MacroError.message("malformed base 64 string: \(b64Argument)") }

		return "String(data: Data(base64Encoded: \(b64Argument))!, encoding: .utf8)!"
	}
}
