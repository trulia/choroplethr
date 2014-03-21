angular.module('AnimatedMaps', ['ngAnimate'])
  .controller('ClientApp', ['$scope', '$window', '$interpolate', function($scope, $window, $interpolate) {
    'use strict';
    /**
     * The normalized date
     * @type {number}
     */
    $scope.dateValue = 1;
    /**
     * A reference for storing the setInterval
     * @type {null}
     */
    $scope.intervalRef = null;
    /**
     * The starting map dateValue
     * @type {number}
     */
    $scope.maxValue = 3;
    /**
     * The ending map dateValue
     * @type {number}
     */
    $scope.minValue = 1;
    /**
     * url template for preloading images
     * @type {string}
     */
    $scope.urlTemplate = $interpolate('assets/images/map_{{dateValue}}.png');
    /**
     * The map image URL being displayed
     * @type {string}
     */
    $scope.mapURL = $scope.urlTemplate({dateValue: $scope.minValue});
    /**
     * Increment the date
     */
    $scope.plusValue = function() {
      $scope.dateValue++;
    }
    /**
     * Decrement the date
     */
    $scope.minusValue = function() {
      $scope.dateValue--;
    }
    /**
     * Start animation traversing through all images in order
     */
    $scope.play = function() {
      $scope.intervalRef = $window.setInterval($scope.nextMap, 1000);
    };
    /**
     * Stop the animation
     */
    $scope.stop = function() {
      $window.clearInterval($scope.intervalRef);
    };
    /**
     * Load Next Map Image
     */
    $scope.nextMap = function() {
      $scope.$apply(function() {
        if ($scope.dateValue < $scope.maxValue) {
          $scope.dateValue = Number($scope.dateValue) + 1;
        } else {
          $window.clearInterval($scope.intervalRef);
        }
      });
    };
    /**
     * Preload Map Images
     */
    $scope.preloadImages = function() {
      for(var i = $scope.minValue; i <= $scope.maxValue; i++) {
        var img = new Image();
        img.src = $scope.urlTemplate({dateValue: i});
      }
    };
    // Preload All Map Images
    $scope.preloadImages();
  }]).run([function() {
    'use strict';
  }]);
