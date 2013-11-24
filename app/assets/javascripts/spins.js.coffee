# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Spin = angular.module 'Spin', [
  'ngRoute',
  'templates',
  'angularLocalStorage',
  'ngCookies',
  'ngSanitize'
]

Spin.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .otherwise { 
      templateUrl: "index.html", 
      controller: 'SpinCtrl' 
    }
]