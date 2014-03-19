angular.module('AnimatedMaps', ['ngAnimate'])
  .controller('ClientApp', ['$scope', '$window', function($scope, $window) {
    'use strict';
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
    'use strict';
  });
