import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockFreePhilosophers(n: 5)
    // let philosophers = lockablePhilosophers(n: 3)
    /* for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    */

    // Partie 1
    let partie1 = philosophers.markingGraph(from: philosophers.initialMarking!)
    print("Réponse pour partie 1")
    print(partie1!.count)

    // Partie 2
    let blocked_philosophers = lockablePhilosophers(n: 5)
    let partie2 = blocked_philosophers.markingGraph(from: blocked_philosophers.initialMarking!)
    print("Réponse pour partie 2")
    print(partie2!.count)

    // Partie 3
    print("Réponse pour partie 3")
    for i in partie2!
    {
      var pas_vide = true
      for (_, successeursByBinding) in i.successors
      {
        if (!(successeursByBinding.isEmpty))
        {
          pas_vide = false
        }

      }
      if (pas_vide)
      {
        print(i.marking)
        // Si un exemple est trouvé, sortir du boucle
        break
      }

    }
}
