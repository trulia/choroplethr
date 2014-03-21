angular.module('AnimatedMaps', ['ngAnimate'])
  .config(['$sceDelegateProvider', function($sceDelegateProvider) {
    $sceDelegateProvider.resourceUrlWhitelist([
      'self',
      'http://en.wikipedia.org/wiki/United_States_presidential_election,_**',
      'https://en.wikipedia.org/w/api.php**'
    ]);
  }])
  .controller('ClientApp', [
    '$scope',
    '$window',
    '$interpolate',
    '$sce',
    '$http',
    function($scope, $window, $interpolate, $sce, $http) {
      'use strict';
      /**
       * The normalized date
       * @type {number}
       */
      $scope.dateValue = 1;
      /**
       * Is there a Wikipedia entry available
       * @type {boolean}
       */
      $scope.isWiki = false;
      /**
       * Images to display
       * @type {Array}
       */
      $scope.images = [];
      /**
       *
       * @returns {number}
       */
      $scope.electionYear = function() {
        return $scope.dateValue == 1 ? 1789 : Number($scope.dateValue - 1) * 4 + 1792;
      };
      /**
       *
       * @returns {*}
       */
      $scope.electionYearURL = function() {
        var url = $interpolate('http://en.wikipedia.org/wiki/United_States_presidential_election,_{{value}}')({value: $scope.electionYear()});
        $sce.trustAsUrl(url);
        return url;
      };
      /**
       *
       * @returns {*}
       */
      $scope.trustedElectionHTML = function() {
        return $sce.trustAsHtml($scope.electionHTML);
      };
      /**
       *
       * @param data
       */
      window.electionText = function(data) {
        angular.forEach(data.query.pages, function(page) {
          $scope.isWiki = page.extract && page.extract.length;
          $scope.$apply(function() {
            $scope.electionTitle = page.title;
            $scope.electionHTML = page.extract;
          });
        });
      };
      window.addImage = function(data) {
        angular.forEach(data.query.pages, function(page) {
          if ($scope.images.indexOf(page.imageinfo[0].url) < 0) {
            $scope.images.push(page.imageinfo[0].url);
          }
        });
      };
      window.electionImages = function(data) {
        angular.forEach(data.query.pages, function(page) {
          angular.forEach(page.images, function(image) {
            var imageRef = image.title.replace('File:', '')
              , imageURL = $interpolate('https://en.wikipedia.org/w/api.php?action=query&titles=Image:{{imageURI}}&prop=imageinfo&iiprop=url&iiurlwidth=100&format=json&callback=addImage')({imageURI: imageRef});
            $http.jsonp(imageURL);
          });
        });
      };
      /**
       *
       */
      $scope.$watch('dateValue', function() {
        $scope.preloadNextImage();
        $scope.images = [];
        var elYear = $scope.electionYear()
          , url = $interpolate('https://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=United_States_presidential_election,_{{value}}&callback=electionText')({value: elYear})
          , imagesUrl = $interpolate('https://en.wikipedia.org/w/api.php?action=query&prop=images&format=json&titles=United_States_presidential_election,_{{value}}&callback=electionImages')({value: elYear});
        $http.jsonp(url);
        $http.jsonp(imagesUrl);
      });
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
      $scope.preloadNextImage = function() {
        var img = new Image();
        img.src = $scope.urlTemplate({dateValue: $scope.dateValue + 1});
      };
      /**
       * Preload All Map Images
       */
      $scope.preloadNextImage();
    }]).run([function() {
    'use strict';
  }]);
