import Cofree_Macro_Core
import Recursive_Macro_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        Recursive_Macro_Core.Derivation.expansion(of: declaration)
            + Cofree_Macro_Core.Derivation.carrier(of: declaration)
            + operation(of: declaration)
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)func histomorphism<Result>(
                _ algebra: (Base<Cofree<Result>>) -> Result
            ) -> Result {
                func history(_ recursive: Self) -> Cofree<Result> {
                    let layer = recursive.project().map(history)
                    return .cofree(algebra(layer), layer)
                }
                switch history(self) {
                case let .cofree(result, _): return result
                }
            }
            """]
    }
}
