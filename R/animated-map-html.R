# this is the html for an animated map
# you need to replace {{minMaps}} and {{maxMaps}} with the min and max indices of 
animated_map_html = '
<html>
  <head>
  <link rel="stylesheet" type="text/css" href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap-theme.min.css">
  <style>
  .animate-enter {
    -webkit-transition: 1s linear all; /* Chrome */
      transition: 1s linear all;
    opacity: 0;
  }

.animate-enter.animate-enter-active {
  opacity: 1;
}

.mapImage {
  height: 400px;
}
</style>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  
  </head>
  <body ng-app="AnimatedMaps" ng-cloak>
  <div ng-controller="ClientApp" class="well well-lg">
  <img class="mapImage" ng-animate=" "animate" " ng-src="map_{{dateValue}}.png">
  <input type="range" class="input-sm" ng-model="dateValue" min="{{minMaps}}" max="{{maxMaps}}">
  <div class="panel" ng-bind="dateValue"></div>
  <button class="btn btn-primary" ng-click="play()">Play</button>
  <button class="btn btn-primary" ng-click="stop()">Stop</button>
  </div>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular.min.js"></script>
  <script src="http://code.angularjs.org/1.2.10/angular-animate.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular-resource.min.js"></script>
  <script>
  angular.module("AnimatedMaps", ["ngAnimate"])
.controller("ClientApp", ["$scope", "$window", function($scope, $window) {
  "use strict";
  $scope.dateValue = 1;
  $scope.intervalRef = null;
  $scope.maxMaps = 3;
  $scope.minMaps = 1;
  $scope.play = function() {
    $scope.intervalRef = $window.setInterval($scope.nextMap, 1000);
  };
  $scope.stop = function() {
    $window.clearInterval($scope.intervalRef);
  };
  $scope.nextMap = function() {
    $scope.$apply(function() {
      if ($scope.dateValue < $scope.maxMaps) {
        $scope.dateValue = Number($scope.dateValue) + 1;
      } else {
        $window.clearInterval($scope.intervalRef);
      }
    });
  };
}]).run(function() {
  "use strict";
});

</script>
  </body>
  </html>
'
  