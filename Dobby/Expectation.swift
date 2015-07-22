/// An expectation that can be matched with an interaction.
public struct Expectation<Interaction>: CustomStringConvertible {
    public private(set) var description: String

    private let matchesFunc: Interaction -> Bool

    /// Initializes a new expectation with the given description and matching
    /// function.
    public init(description: String = "<func>", matches matchesFunc: Interaction -> Bool) {
        self.description = description
        self.matchesFunc = matchesFunc
    }

    /// Checks whether the given interaction matches this expectation.
    public func matches(interaction: Interaction) -> Bool {
        return matchesFunc(interaction)
    }
}

/// Returns a new expectation with the given matching function.
///
/// - SeeAlso: `Expectation.init<Interaction>(description: String, matches: Interaction -> Bool)`
public func matches<Interaction>(matches: Interaction -> Bool) -> Expectation<Interaction> {
    return Expectation(matches: matches)
}


public extension Expectation {
    /// Initializes a new expectation that matches anything.
    public init() {
        self.init(description: "_") { _ in true }
    }
}

/// Returns a new expectation that matches anything.
///
/// - SeeAlso: `Expectation.init<Interaction>()`
public func any<Interaction>() -> Expectation<Interaction> {
    return Expectation()
}

public extension Expectation where Interaction: Equatable {
    public typealias Value = Interaction

    /// Initializes a new expectation that matches the given value.
    public init(value: Value) {
        self.init(description: "\(value)") { $0 == value }
    }
}

/// Returns a new expectation that matches the given value.
///
/// - SeeAlso: `Expectation.init<Interaction>(value: Value)`
public func value<Value: Equatable>(value: Value) -> Expectation<Value> {
    return Expectation(value: value)
}

/// Conforming types can be converted to an expectation.
public protocol ExpectationConvertible {
    /// The type of interaction with which this type, when converted to an
    /// expectation, can be matched.
    typealias InteractionType

    /// Converts this type to an expectation.
    func expectation() -> Expectation<InteractionType>
}

extension Expectation: ExpectationConvertible {
    public func expectation() -> Expectation<Interaction> {
        return self
    }
}

/// Returns a new expectation that matches the given 1-tuple.
public func tuple<A: ExpectationConvertible>(arg1: A) -> Expectation<(A.InteractionType)> {
    return Expectation(description: "(\(arg1))") { interaction in
        return arg1.expectation().matches(interaction)
    }
}

/// Returns a new expectation that matches the given 2-tuple.
public func tuple<A: ExpectationConvertible, B: ExpectationConvertible>(arg1: A, _ arg2: B) -> Expectation<(A.InteractionType, B.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
    }
}

/// Returns a new expectation that matches the given 3-tuple.
public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
    }
}

/// Returns a new expectation that matches the given 4-tuple.
public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C, _ arg4: D) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3), \(arg4))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
            && arg4.expectation().matches(interaction.3)
    }
}

/// Returns a new expectation that matches the given 5-tuple.
public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible, E: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType, E.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3), \(arg4), \(arg5))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
            && arg4.expectation().matches(interaction.3)
            && arg5.expectation().matches(interaction.4)
    }
}
