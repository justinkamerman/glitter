window.VisualizationController = class VisualizationController
  constructor: ($scope, $window) ->
    @retweets = $window.retweets

    @scope = $scope
    @scope.selectedRetweets = []
    @scope.selectOptions = placeholder: 'Select Retweets'
    @scope.retweets = @retweets
    @scope.data = {}

    @scope.$watch 'selectedRetweets', =>
      @_updateData()
    , true

  _updateData: ->
    update = @_mergeData(@_getSelectedRetweets())
    update = @_calculateDistancesFromOrigin(update)
    @scope.data = update

  _getSelectedRetweets: ->
    (@_findRetweetById(selectedId) for selectedId in @scope.selectedRetweets || [])

  _findRetweetById: (id) ->
    id = parseInt(id, 10)
    results = (retweet for retweet in @retweets when retweet.tweet.id == id)
    if results.length == 1 then results[0] else throw new Error("found #{results.length} results for tweet with id: #{id}")

  _mergeData: (retweets) ->
    merger = new TweetMerge()
    merger.add(retweet) for retweet in retweets
    merger.merge()

  _calculateDistancesFromOrigin: (retweets) ->
    new DistanceFromOrigin(retweets).calculateDistancesFromOrigin()

VisualizationController.$inject = ['$scope', '$window']