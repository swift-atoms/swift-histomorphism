import Histomorphism_Macro_Core
import SwiftSyntax
import SwiftSyntaxBuilder
import Testing

enum `Access Tests` {}

extension `Access Tests` {
    @Suite
    struct `Generated access level` {
        private func access(of source: DeclSyntax) throws -> String? {
            let declaration = try #require(source.as(EnumDeclSyntax.self))
            let generated = try #require(Derivation.expansion(of: declaration).first?.as(FunctionDeclSyntax.self))
            return generated.modifiers.first?.name.text
        }

        @Test
        func `a public enum gets a public method`() throws {
            #expect(try access(of: "public indirect enum Count { case zero }") == "public")
        }

        @Test
        func `a package enum gets a package method`() throws {
            #expect(try access(of: "package indirect enum Count { case zero }") == "package")
        }

        @Test
        func `an internal or private enum gets a method without a modifier`() throws {
            #expect(try access(of: "indirect enum Count { case zero }") == nil)
            #expect(try access(of: "private indirect enum Count { case zero }") == nil)
        }
    }
}
