@SpinCtrl = ['$scope', '$http', 'storage', ($scope, $http, storage) ->

  class CoinAnimator
    constructor: () ->
      @coin = document.getElementById("coin")
      @count = 0
      @stopAt = null
      @minSpins = Math.floor(Math.random() * 5) + 1
      @stoppedCbs = []

    wrongPosition: ->
      result = @count % 2 == (if @stopAt then 0 else 1)

    stopped: (cb) ->
      @stoppedCbs.push cb

    safeSpinDone: =>
      $("#coin").unbind "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", @safeSpinDone
      @start(false)

    spin: =>
      if @stopAt == null or @count < @minSpins or @wrongPosition()
        @count += 1
        @coin.toggleClassName "flipped"
      else
        cb() for cb in @stoppedCbs
        $("#coin").unbind "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", @spin

    start: (invert) =>
      if invert == true
        $("#coin").bind "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", @safeSpinDone
      else
        $("#coin").bind "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", @spin
      @coin.toggleClassName "flipped"

    setStopAt: (where) ->
      @stopAt = where

  uniqueId = (length=20) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

  getResult = (cb) ->
    $http.post("/spins.json", {
      game_id: $scope.data.gameId,
      name: $scope.data.name
    })
    .success (data) ->
      cb(data)
    .error ->
      console.log 'spin error!'
      cb({win:false, score:0})

  $scope.data = {
    score: 1,
    gameNo: 0,
    invert: false,
    fillingName: false
  }

  storage.bind $scope, 'data.highscore', 
      { defaultValue: 0, storeName: 'highscore' }
  storage.bind $scope, 'data.name', 
      { defaultValue: null, storeName: 'name' }
  storage.bind $scope, 'data.highscoreGameId',
      { defaultValue: null, storeName: 'highscoreGameId' }

  $scope.newGame = () ->
    $scope.data.gameId = uniqueId()
    $scope.data.gameNo += 1

  $scope.newGame()

  $scope.getInvert = ->
    if $scope.data.invert
      $scope.data.invert = false
      return true
    return false

  $scope.saveName = ->
    $scope.data.fillingName = false
    $scope.saveHighscore()
    $http.put("/spins/#{$scope.data.lastGameId}", {
      name: $scope.data.name
    })
    .success (data) ->
      console.log 'saved name'
    .error ->
      console.log 'failed to save name'

  $scope.saveHighscore = ->
    if $scope.data.lastScore > $scope.data.highscore
      $scope.data.highscore = $scope.data.lastScore
      $scope.data.highscoreGameId = $scope.data.lastGameId

  $scope.spin = ->
    $scope.data.busy = true
    animator = new CoinAnimator()
    animator.start($scope.getInvert())
    getResult (result) =>
      animator.stopped => 
        if result.win
          $scope.$apply -> $scope.data.score = result.score
        else
          $scope.$apply ->
            $scope.data.lastGameId = $scope.data.gameId
            $scope.newGame()
            $scope.data.invert = true
            $scope.data.score = 1
            $scope.data.lastScore = result.score
            unless $scope.data.name? then $scope.data.fillingName = true else $scope.saveHighscore()
        $scope.$apply -> $scope.data.busy = false
      animator.setStopAt(result.win)

  class Sharer
    constructor: (gameId) -> @gameId = gameId
    shareFacebook: () ->
      window.open('https://www.facebook.com/sharer/sharer.php?u=' + @highscoreGameUrl(), 
      'facebook-share-dialog', 
      'width=626,height=436')
    highscoreGameUrl: ->
      encodeURIComponent(window.location.protocol + '//' + window.location.hostname + "/g#{@gameId}")

  $scope.shareFacebook = ->
    sharer = new Sharer($scope.data.highscoreGameId)
    sharer.shareFacebook()
    return false
]