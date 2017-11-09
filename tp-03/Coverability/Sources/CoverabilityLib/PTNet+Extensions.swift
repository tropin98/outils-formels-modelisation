import PetriKit

public extension PTTransition
{
  public func fireableForCoverability(from marking: CoverabilityMarking) -> Bool
  {
    for precon in self.preconditions
    {
      if marking[precon.place]! < Token.some(precon.tokens)
      {
        return false
      }
      return true
    }
  }
  public func fireForCoverability(from marking: CoverabilityMarking) -> CoverabilityMarking?
  {
    guard self.fireableForCoverability (from: marking) else
    {
      return nil
    }

    var res = marking
    for precon in self.preconditions
    {
        res[precon.place]! -= precon.tokens
    }
    for precon in self.postconditions
    {
        res[precon.place]! += precon.tokens
    }
    return res

  }
  /*
  public func fire(from marking: PTMarking) -> PTMarking? {
      guard self.isFireable(from: marking) else {
          return nil
      }

      var result = marking
      for arc in self.preconditions {
          result[arc.place]! -= arc.tokens
      }
      for arc in self.postconditions {
          result[arc.place]! += arc.tokens
      }

      return result
  } */
}

/*
public extension PTTransition {
   public func tirableOuPas (from CoverabilityMarking) -> Bool
   {
     for precon in self.preconditions
     {
       if marking(precon.place) < Token.some(precon.tokens)
       {
         return false
       }
       return true
     }
   }
}
*/

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.

        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

        // Define the arrays for visited and not visited places.
        visited_places = []
        not_visited_places = [successors]

        // Same for transitions.
        fired_transitions = []
        not_fired_transitions = []

        // Find the initial Place.


        // Use firings to see possible branches of the tree.
        for i in not_visited_places
        {
        for j in not_fired_transitions

        {
          // if transition is fireable from place A to place B
          if fireableForCoverability(from: CoverabilityMarking){

          // Add them to the graph
          visited_places.append(not_visited_places[i])
          fired_transitions.append(not_fired_transitions[j])

          // Remove visited places from the array
          not_visited_places[i] = nil
          not_fired_transitions[j] = nil
          }
          else return coverabilityGraph // with a different marking

        }
        }

        return CoverabilityGraph(marking: marking)
    }

}
