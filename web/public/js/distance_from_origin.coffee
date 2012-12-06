window.DistanceFromOrigin = class
  constructor: (retweet) ->
    @retweet = retweet
    @tweets = if retweet.tweet? then [retweet.tweet] else retweet.tweets

  calculateDistancesFromOrigin: ->
    return @retweet if !@tweets? || @tweets.length == 0

    nodeParents = {}
    nodes = @retweet.nodes
    links = @retweet.links
    originator = @tweets[0].author

    for link in links
      source = nodes[link.source].id
      target = nodes[link.target].id
      nodeParents[target] = source

    nodes = for node in nodes
      node = @_clone(node)
      if node.id == originator
        node.distance = 0
      else
        node.distance = @_walkToOriginator(nodeParents, node.id, originator)
      node

    return tweets: @tweets, nodes: nodes, links: links

  _walkToOriginator: (parents, currentNode, originator, count = 0) ->
    parent = parents[currentNode]
    if parent == originator
      count + 1
    else if !parent?
      -(count + 1)
    else
      @_walkToOriginator(parents, parent, originator, count + 1)

  _clone: (obj) ->
    clone = {}
    clone[k] = v for k, v of obj
    clone