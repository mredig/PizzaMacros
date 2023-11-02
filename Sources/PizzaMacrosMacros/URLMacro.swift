import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public enum URLMacro: ExpressionMacro {
	public static func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in context: some MacroExpansionContext
	) throws -> ExprSyntax {
		guard
			let argument = node.argumentList.first?.expression,
			let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
			segments.count == 1,
			case .stringSegment(let literalSegment)? = segments.first
		else {
			throw MacroError.message("#URL requires a static string literal")
		}

		guard URL(string: literalSegment.content.text) != nil else {
			throw MacroError.message("malformed url: \(argument)")
		}

		return "URL(string: \(argument))!"
	}
}
