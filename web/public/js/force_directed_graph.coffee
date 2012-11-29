window.ForceDirectedGraph = class ForceDirectedGraph
  constructor: (el, data) ->
    @el = el
    @data = {}
    @reach = 0
    @scale = 1
    @_initializeGraph()
    @_drawGraph()

  _initializeGraph: ->
    @link = null
    @node = null
    @text = null
    @textTarget = false
    width = @el.width()
    height = @el.height()

    # create the visualization container
    @visualization = d3.select(@el[0]).append('svg').
      attr('width', width).
      attr('height', height)

    # configure the layout
    @force = d3.layout.force().
      size([width, height]).
      charge(-100 * @scale).
      linkDistance(50 * @scale).
      on 'tick', =>
        @link.attr
          'x1': (d) -> d.source.x
          'y1': (d) -> d.source.y
          'x2': (d) -> d.target.x
          'y2': (d) -> d.target.y
        @node.attr
          'cx': (d) -> d.x
          'cy': (d) -> d.y
        @text.attr('transform', "translate(#{@textTarget.x}, #{@textTarget.y})") if @textTarget

  update: (data) ->
    @data = data
    @_clearGraph()
    @_drawGraph()

  # get a list of a target node's children
  _childNodes: (d) =>
    if d.children? then d.children.map((child) => @node[0][child]).filter((child) -> child) else []

  # get a list of a target node's parents
  _parentNodes: (d) =>
    if d.parents? then d.parents.map((parent) => @node[0][parent]).filter((parent) -> parent) else []

  # determine if two nodes are connected
  _connected: (d, o) ->
    o.index == d.index ||
      (o.children? && o.children.indexOf(d.index) != -1) ||
      (d.children? && d.children.indexOf(o.index) != -1) ||
      (o.parents?  && o.parents.indexOf(d.index)  != -1) ||
      (d.parents?  && d.parents.indexOf(o.index)  != -1)

  _calculateSize: (d) ->
    1.5 * Math.log(d.followers_count || 1)

  _nodeColor: (d) =>
    d3.hsl(@_calculateSize(d) * 300, 0.7, 0.725)

  _onNodeMouseover: (d, node) =>
    @textTarget = d
    @text.attr('transform', 'translate(' + d.x + ',' + d.y + ')').text(d.screen_name).style('display', null)
    d3.select(node).classed('hover', true)
    d3.selectAll(@_childNodes(d)).classed('childHover', true).style('stroke', @_nodeColor)
    d3.selectAll(@_parentNodes(d)).classed('parentHover', true).style('stroke', @_nodeColor)

  _onNodeMouseout: (d, node) =>
    @textTarget = false
    @text.style('display', 'none')
    d3.select(node).classed('hover', false)
    d3.selectAll(@_childNodes(d)).classed('childHover', false).style('stroke', null)
    d3.selectAll(@_parentNodes(d)).classed('parentHover', false).style('stroke', null)

  _onNodeClick: (d) =>
    if @focus == d then @_removeFocusFromNode(d) else @_setFocusToNode(d)

  _setFocusToNode: (d) =>
    @focus = d
    @node.style 'opacity', (o) =>
      o.active = @_connected(d, o)
      if o.active then 1 else 0.2
    @force.charge((o) => (if o.active then -100 else -5) * @scale).
      linkDistance((l) => (l.source.active && if l.target.active then 100 else 20) * @scale).
      linkStrength((l) => (l.source == d || if l.target == d then 1 else 0) * @scale).
      start()
    @link.style('opacity', (l) -> l.source.active && if l.target.active then 0.2 else 0.02)

  _removeFocusFromNode: (d) =>
    @force.charge(-100 * @scale)
      .linkDistance(50 * @scale)
      .linkStrength(1)
      .start()
    @node.style('opacity', 1)
    @link.style('opacity', (d) -> 0.3)
    @focus = false

  _clearGraph: ->
    @link.remove()
    @node.remove()
    @text.remove()
    @force.stop()

  _drawGraph: ->
    nodes = @data.nodes || []
    links = @data.links || []

    # cache the connection of each node link
    links.forEach (link) ->
      source = nodes[link.source]
      target = nodes[link.target]

      source.children = source.children || []
      source.children.push(link.target)

      target.parents = target.parents || []
      target.parents.push(link.source)

    # apply the layout
    @force.nodes(nodes).links(links).start()

    @link = @visualization.selectAll('line.link').data(links)
    @node = @visualization.selectAll('circle.node').data(nodes, (d) -> d.screen_name)

    @link.enter().insert('line', '.node').attr
      'class': 'link'
      'x1': (d) -> d.source.x
      'y1': (d) -> d.source.y
      'x2': (d) -> d.target.x
      'y2': (d) -> d.target.y

    onNodeMouseover = @_onNodeMouseover
    onNodeMouseout = @_onNodeMouseout

    @node.enter().append('circle').attr(
      'class': (d) -> "node node-#{d.id}"
      'cx': (d) -> d.x
      'cy': (d) -> d.y
      'r':  (d) => @scale * @_calculateSize(d)
    ).style('fill', @_nodeColor).
    call(@force.drag).
    on('mouseover', (d) -> onNodeMouseover(d, this)).
    on('mouseout', (d) -> onNodeMouseout(d, this)).
    on('click', @_onNodeClick)

    @text = @visualization.selectAll('.nodetext').data([
      [-1.5,  1.5,  1], # "Shadows"
      [ 1.5,  1.5,  1],
      [-1.5, -1.5,  1],
      [ 1.5, -1.5,  1],
      [ 0.0,  0.0,  0]  # Actual Text
    ]).enter().insert('text', ':last-child').
      attr('class', 'nodetext').
      classed('shadow', (d) -> d[2]).
      attr
        'dy': (d) -> d[0] - 10
        'dx': (d) -> d[1]
        'text-anchor': 'middle'

    @force.resume()


#  document.addEventListener('keyup', function(e) {
#    if(e.keyCode === 27 && focus) {
#    d3.select(focus).each(function() {
#    onNodeClick(focus);
#      });
#  }
#  });