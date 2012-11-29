window.TweetMerge = class TweetMerge
  constructor: ->
    @_retweets = (retweet for retweet in arguments)

  add: (retweet) ->
    @_retweets.push(retweet)

  merge: ->
    @_merged = {}
    @_cache = nodes: [], nodePositions: {}, links: [], linkPositions: {}

    for retweet in @_retweets
      @_mergeTweet(retweet.tweet)
      @_mergeNodes(retweet.nodes)
      @_mergeLinks(retweet.links, retweet.nodes)

    @_cache = null
    @_merged

  _mergeTweet: (tweet) ->
    (@_merged.tweets ||= []).push(@_clone(tweet))

  _mergeNodes: (nodes) ->
    @_mergeNode(node) for node in nodes
    @_merged.nodes = @_cache.nodes

  _mergeNode: (node) ->
    cachedNodes = @_cache.nodes
    nodePositions = @_cache.nodePositions
    nodePosition = nodePositions[node.id]
    if nodePosition?
      cachedNodes[nodePosition].count += 1
    else
      node = @_clone(node)
      nodePositions[node.id] = cachedNodes.length
      cachedNodes.push(node)
      node.count = 1

  _mergeLinks: (links, retweetNodes) ->
    @_mergeLink(link, retweetNodes) for link in links
    @_merged.links = @_cache.links

  _mergeLink: (link, retweetNodes) ->
    cachedLinks = @_cache.links
    linkPositions = @_cache.linkPositions
    nodePositions = @_cache.nodePositions
    sourceNodeId = retweetNodes[link.source].id
    targetNodeId = retweetNodes[link.target].id
    key = "#{sourceNodeId}:#{targetNodeId}"
    unless linkPositions[key]?
      linkPositions[key] = cachedLinks.length
      cachedLinks.push(source: nodePositions[sourceNodeId], target: nodePositions[targetNodeId])

  _clone: (obj) ->
    clone = {}
    clone[k] = v for k, v of obj
    clone