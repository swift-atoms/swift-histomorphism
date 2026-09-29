import Cofree_Macro
import Functor_Base_Macro
import Recursive_Macro
import Histomorphism_Macro
import Testing

@Cofree
@FunctorBase
@Recursive
@Histomorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

private func fibonacci(_ layer: Count.Base<Count.Cofree<Int>>) -> Int {
    switch layer {
    case .zero: 0
    case .successor(.cofree(_, .zero)): 1
    case let .successor(.cofree(previous, .successor(.cofree(beforePrevious, _)))): previous + beforePrevious
    }
}

@Suite
struct `Histomorphism boundaries` {
    @Test
    func `the base case folds without history`() {
        #expect(Count.zero.histomorphism(fibonacci) == 0)
    }

    @Test
    func `each layer sees two layers of history`() {
        let ten = (0..<10).reduce(Count.zero) { value, _ in .successor(value) }
        #expect(ten.histomorphism(fibonacci) == 55)
    }
}
