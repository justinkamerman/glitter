# create application module
app = angular.module('retweet', ['ui']);

# register angular-ui config
app.value('ui.config', {});

# create force-directed graph directive
app.directive 'forceDirectedGraph', () ->
  directive =
    restrict: 'E'
    replace: true
    template: '<div class="force-directed-graph"></div>'
    link: (scope, element, attrs) ->
      dataProperty = attrs.data
      graph = new ForceDirectedGraph(element, scope.$eval(dataProperty))
      scope.$watch dataProperty, (newVal, oldVal, scope) ->
        graph.update(newVal) if newVal?
      graph