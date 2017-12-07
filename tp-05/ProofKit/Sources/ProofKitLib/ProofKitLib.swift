infix operator =>: LogicalDisjunctionPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
      switch self {
      // etape 1
      case .proposition(_):
        return self
      case .implication(let a, let b):
        return !a.dnf || b.dnf

      // etape 2
      case .negation(let a):
        switch a {
        case .proposition(_):
          return self
        case .negation(let b):
            return b.dnf
        case .disjunction(let b, let c):
            return (!b).dnf && (!c).dnf
        case .conjunction(let b, let c):
            return (!b).dnf || (!c).dnf
        case .implication(_):
            return (!a.dnf).dnf
        }

      // etape 3
    case .conjunction(let a, let b):
        switch a {
        case .disjunction(let c, let d):
          switch b {
          case .disjunction(let e, let f):
            return (c.dnf && e.dnf) || (c.dnf && f.dnf) || (d.dnf && e.dnf) || (d.dnf && f.dnf)
          default:
            return (c.dnf && b.dnf) || (d.dnf && b.dnf)
          }

          //return (c.cnf || b.cnf) && (d.cnf || b.cnf)
        default:
          switch b {
          case .disjunction(let g, let h):
            return (a.dnf && g.dnf) || (a.dnf && h.dnf)
          default:
            return a.dnf && b.dnf

          }

        }
  /*
        switch b {

        case .conjunction(let c, let d):
          return (a.cnf || c.cnf) && (a.cnf || d.cnf)
        default:
          return a.cnf || b.cnf
        }
  */
case .disjunction(let a, let b):
        return a.dnf || b.dnf
      }
      return self
  }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        switch self {
        // etape 1
        case .proposition(_):
          return self
        case .implication(let a, let b):
          return !a.cnf || b.cnf

        // etape 2
        case .negation(let a):
          switch a {
          case .proposition(_):
            return self
          case .negation(let b):
              return b.cnf
          case .disjunction(let b, let c):
              return (!b).cnf && (!c).cnf
          case .conjunction(let b, let c):
              return (!b).cnf || (!c).cnf
          case .implication(_):
              return (!a.cnf).cnf
          }

        // etape 3
        case .disjunction(let a, let b):
          switch a {
          case .conjunction(let c, let d):
            switch b {
            case .conjunction(let e, let f):
              return (c.cnf || e.cnf) && (c.cnf || f.cnf) && (d.cnf || e.cnf) && (d.cnf || f.cnf)
            default:
              return (c.cnf || b.cnf) && (d.cnf || b.cnf)
            }

            //return (c.cnf || b.cnf) && (d.cnf || b.cnf)
          default:
            switch b {
            case .conjunction(let g, let h):
              return (a.cnf || g.cnf) && (a.cnf || h.cnf)
            default:
              return a.cnf || b.cnf

            }

          }
/*
          switch b {

          case .conjunction(let c, let d):
            return (a.cnf || c.cnf) && (a.cnf || d.cnf)
          default:
            return a.cnf || b.cnf
          }
*/
        case .conjunction(let a, let b):
          return a.cnf && b.cnf
        }
        return self
    }

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
