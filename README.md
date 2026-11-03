# swift-histomorphism

Use this package when folding a recursive enum where each step needs the results already computed for earlier layers, not just the immediate children: the course-of-values pattern behind Fibonacci-style recurrences and dynamic programming over a structure. Start from `@Histomorphism`, attached to an `indirect enum` that also carries `@Cofree`, `@FunctorBase` and `@Recursive`, which supply the `Base`, `Cofree` and `project()` the generated `histomorphism` method is built on. When the algebra only needs each child's result, use swift-catamorphism; when it needs each original child alongside its result, use swift-paramorphism.

## Laws

- The fold runs bottom-up: every child's result and history are complete before the algebra sees the layer that contains it, and the algebra is called exactly once per layer.
- Each child in the layer the algebra receives is a `Cofree<Result>` pairing that child's result with the child's own layer of annotated children, down to the leaves. Reaching deeper into this history reads stored results and never calls the algebra again.
- Nothing is cached between calls: each call rebuilds the full history, holding one result per layer of the value in memory, and the recursion goes as deep on the stack as the value is deep.
- A base case receives a layer with no history.
- The generated method is `public` when the enum is declared `public`, and internal otherwise.
- Attaching `@Histomorphism` to anything other than an enum fails at expansion.
