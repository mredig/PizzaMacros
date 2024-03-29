import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public enum BitshiftLiteralMacro: ExpressionMacro {
	public static func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in context: some MacroExpansionContext
	) throws -> ExprSyntax {
		guard
			let argument = node.argumentList.first,
			case let expression = argument.expression,
			let infix = expression.as(InfixOperatorExprSyntax.self),
			let leftOperand = infix.leftOperand.as(IntegerLiteralExprSyntax.self)?.trimmed.literal,
			let op = infix.operator.as(BinaryOperatorExprSyntax.self)?.operator.text,
			let rightOperand = infix.rightOperand.as(IntegerLiteralExprSyntax.self)?.trimmed.literal,
			let digit = Int(leftOperand.text),
			op == "<<",
			let shift = Int(rightOperand.text)
		else {
			throw MacroError.message("#Bitshift requires a left bitshifting literal")
		}

		return "\(raw: digit << shift)"
	}
}
