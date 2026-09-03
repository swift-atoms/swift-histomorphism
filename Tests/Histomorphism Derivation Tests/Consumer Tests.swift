import Histomorphism_Derivation
import Testing

@Histomorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `histomorphism exposes annotated history`() {
    let two = Natural.successor(.successor(.zero))
    let count = two.histomorphism {
        (layer: Natural.Base<Natural.Cofree<Int>>) -> Int in
        switch layer {
        case .zero: 0
        case let .successor(.cofree(child, _)): child + 1
        }
    }
    #expect(count == 2)
}
