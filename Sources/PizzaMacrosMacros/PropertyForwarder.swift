import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct PropertyForwarderPropertyMacro: AccessorMacro {
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
			return explicitForwardedPath(arguments: arguments)
		} else {
			return implicitForwardedPath(arguments: arguments, identifier: identifier)
		}
	}

	private static func explicitForwardedPath(arguments: LabeledExprListSyntax) -> [AccessorDeclSyntax] {
		let first = arguments.startIndex
		let second = arguments.index(after: first)
		let parentKeypath = arguments[first].expression

		let forwardedKeypath = arguments[second].expression

		return [
			"""
			get { self[keyPath: \(parentKeypath)][keyPath: \(forwardedKeypath)] }
			""",
			"""
			set { self[keyPath: \(parentKeypath)][keyPath: \(forwardedKeypath)] = newValue }
			"""
		]
	}

	private static func implicitForwardedPath(arguments: LabeledExprListSyntax, identifier: TokenSyntax) -> [AccessorDeclSyntax] {
		let first = arguments.startIndex
		let parentKeypath = arguments[first].expression

		guard
			let keyPath = parentKeypath.as(KeyPathExprSyntax.self)
		else { return [] }

		let forwardedKeypath = "\\.\(identifier)"

		return [
			"""
			get { self[keyPath: \(parentKeypath)][keyPath: \(raw: forwardedKeypath)] }
			""",
			"""
			set { self[keyPath: \(parentKeypath)][keyPath: \(raw: forwardedKeypath)] = newValue }
			"""
		]
	}
}
