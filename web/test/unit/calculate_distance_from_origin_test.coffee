describe 'DistanceFromOrigin', ->
  describe 'merging a simple data set', ->
    { tweet3 } = FIXTURES
    distanceDecorator = new DistanceFromOrigin(tweet3)
    decorated = distanceDecorator.calculateDistancesFromOrigin()

    it 'should decorator each node with the distance from the originating tweet', ->
      expect(decorated.nodes).toEqual([
        { id: 1, screen_name: "originator", distance: 0 }
        { id: 2, screen_name: "d1a", distance: 1 }
        { id: 3, screen_name: "d1b", distance: 1 }
        { id: 4, screen_name: "d1a_d2a", distance: 2 }
        { id: 5, screen_name: "d1a_d2b", distance: 2 }
        { id: 6, screen_name: "d1a_d2a_d3a", distance: 3 }
        { id: 7, screen_name: "no_link_to_originator", distance: -1 }
        { id: 8, screen_name: "child_of_no_link_to_originator", distance: -2 }
      ])
