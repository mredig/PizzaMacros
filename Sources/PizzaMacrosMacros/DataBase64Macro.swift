import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public enum DataBase64Macro: ExpressionMacro {
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
			throw MacroError.message("#Data(base64Encoded:) requires a static string literal")
		}

		guard
			Data(base64Encoded: literalSegment.content.text) != nil
		else { throw MacroError.message("malformed base 64 string: \(b64Argument)") }

		return "Data(base64Encoded: \(b64Argument))!"
	}
}
