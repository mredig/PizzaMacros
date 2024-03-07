import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct PropertyForwarderParentPropertyMacro: AccessorMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingAccessorsOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [AccessorDeclSyntax] {
		guard
			let varDecl = declaration.as(VariableDeclSyntax.self),
			let binding = varDecl.bindings.first,
			let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
			binding.accessorBlock == nil,
			case .argumentList(let arguments) = node.arguments,
			1...2 ~= arguments.count
		else { return [] }

		if arguments.count == 2 {
			return explicitParentPath(arguments: arguments)
		} else {
			return implicitParentPath(arguments: arguments, identifier: identifier)
		}
	}

	private static func explicitParentPath(arguments: LabeledExprListSyntax) -> [AccessorDeclSyntax] {
		let first = arguments.startIndex
		let second = arguments.index(after: first)
		guard
			let parentKeypath = arguments[first].expression.as(KeyPathExprSyntax.self),
			let forwardedKeypath = arguments[second].expression.as(KeyPathExprSyntax.self)
		else { return [] }

		return [
			"""
			get { self\(parentKeypath.components)\(forwardedKeypath.components) }
			""",
			"""
			set { self\(parentKeypath.components)\(forwardedKeypath.components) = newValue }
			"""
		]
	}

	private static func implicitParentPath(arguments: LabeledExprListSyntax, identifier: TokenSyntax) -> [AccessorDeclSyntax] {
		let first = arguments.startIndex
		guard
			let parentKeypath = arguments[first].expression.as(KeyPathExprSyntax.self)
		else { return [] }

		let forwardedKeypath = ".\(identifier)"

		return [
			"""
			get { self\(parentKeypath.components)\(raw: forwardedKeypath) }
			""",
			"""
			set { self\(parentKeypath.components)\(raw: forwardedKeypath) = newValue }
			"""
		]
	}
}
