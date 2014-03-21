angular.module('AnimatedMaps', ['ngAnimate'])
  .config(['$sceDelegateProvider', function($sceDelegateProvider) {
    $sceDelegateProvider.resourceUrlWhitelist([
      'self',
      'http://en.wikipedia.org/wiki/United_States_presidential_election,_**']);
  }])
  .controller('ClientApp', ['$scope', '$window', '$interpolate', '$sce', '$http', function($scope, $window, $interpolate, $sce) {
    'use strict';
    /**
     * The normalized date
     * @type {number}
     */
    $scope.dateValue = 1;
    $scope.electionYear = function() {
      return $scope.dateValue == 1 ? 1789 : Number($scope.dateValue - 1) * 4 + 1792;
    };
    $scope.electionYearURL = function() {
      var url = $interpolate('http://en.wikipedia.org/wiki/United_States_presidential_election,_{{value}}')({value: $scope.electionYear()});
      $sce.trustAsUrl(url);
      return url;
    }
    /**
     * A reference for storing the setInterval
     * @type {null}
     */
    $scope.intervalRef = null;
    /**
     * The starting map dateValue
     * @type {number}
     */
    $scope.maxValue = 57;
    /**
     * The ending map dateValue
     * @type {number}
     */
    $scope.minValue = 1;
    /**
     * url template for preloading images
     * @type {string}
     */
    $scope.urlTemplate = $interpolate('assets/images/choropleth_{{dateValue}}.png');
    /**
     * The map image URL being displayed
     * @type {string}
     */
    $scope.mapURL = function() {
      return $scope.urlTemplate({dateValue: $scope.dateValue});
    };
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
