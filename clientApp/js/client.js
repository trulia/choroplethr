angular.module('AnimatedMaps', ['ngAnimate'])
  .controller('ClientApp', ['$scope', function($scope) {
    'use strict';
    $scope.dateValue = 0;
    $scope.intervalRef = null;
    $scope.maxMaps = 100;
    $scope.minMaps = 0;
    $scope.play = function() {
      $scope.intervalRef = setInterval($scope.nextMap, 1000);
    };
    $scope.stop = function() {
      clearInterval($scope.intervalRef);
    };
    $scope.nextMap = function() {
      $scope.$apply(function() {
        $scope.dateValue = Number($scope.dateValue) + 1;
      });
    };
  }]).run(function() {
    'use strict';
  });
