#' Animate a list of choropleths
#' 
#' Given a list of choropleths, represented as ggplot2 objects
#' \enumerate{
#' \item Save the individual images to the working directory with the naming convention "choropleth_1.png", "choropleth_2.png", etc.
#' \item Write a file called "animated_choropleth.html" which contains a viewer which animates them.
#' }
#'
#' @param choropleths A list of choropleths represented as ggplot2 objects. 
#' @return Nothing.  However, a variable number of files are written to the current working directory.
#' 
#' @keywords choropleth animation
#' @author Ari Lamstein (R code) and Brian Johnson (JavaScript, HTML and CSS code)
#' 
#' @importFrom ggplot2 ggsave
#' @importFrom stringr str_replace fixed
#' @export
#' @examples
#' \dontrun{
#' data(df_president_ts)
#' ?df_president_ts # time series of all US presidential elections 1789-2012
#'
#' # create a list of choropleths of presidential election results for each year
#' choropleths = list()
#' for (i in 2:(ncol(df_president_ts))) {
#'   df           = df_president_ts[, c(1, i)]
#'   colnames(df) = c("region", "value")
#'   title        = paste0("Presidential Election Results: ", colnames(df_president_ts)[i])
#'   choropleths[[i-1]] = state_choropleth(df, title=title)
#' }
#'
#' # set working directory and animate
#' setwd("~/Desktop")
#' choroplethr_animate(choropleths)
#' }
choroplethr_animate = function(choropleths)
{
  stopifnot(is.list(choropleths))
  print(paste0("All files will be written to the current working directory: ", getwd(), " . To change this use setwd()"))
  print("Now writing individual choropleth files there as 'choropleth_1.png', 'choropleth_2.png', etc.")
  
  # save individual frames
  for (i in 1:length(choropleths))
  {
    filename = paste0("choropleth_", i, ".png")
    ggsave(filename=filename, plot=choropleths[[i]])
  }  
  
  # this is the html for an animated map
  # you need to replace {{minMaps}} and {{maxMaps}} with the min and max indices of frames
  txt = '
  <html>
  <head>
  <title>Choroplethr Playr</title>
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
  width: 100%;
  }
  
  .ranger {
  width: 500px;
  }
  </style>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  </head>
  <body ng-app="AnimatedMaps" ng-cloak ng-controller="ClientApp">
  <div class="container">
  <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container-fluid">
  <!-- Brand and toggle get grouped for better mobile display -->
  <div class="navbar-header">
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
  <span class="sr-only">Toggle navigation</span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  </button>
  <a class="navbar-brand" href="#">Choroplethr Playr</a>
  </div>
  <form class="navbar-form navbar-right" role="search">
  <div class="form-group">
  <button type="button" class="btn btn-default" ng-click="play()">&nbsp;<span class="glyphicon glyphicon-play glyphicon-inverse"></span>
  </button>
  <button type="button" class="btn btn-default" ng-click="stop()"><span class="glyphicon glyphicon-stop"></span>&nbsp;
  </button>
  <button type="button" class="btn btn-default" ng-click="minusValue()">
  <span class="glyphicon glyphicon-minus"></span>&nbsp;</button>
  <input type="range" class="form-control ranger" ng-model="dateValue" min="{{minValue}}" max="{{maxValue}}">
  <button type="button" class="btn btn-default" ng-click="plusValue()">&nbsp;<span class="glyphicon glyphicon-plus"></span>
  </button>
  </div>
  </form>
  </div>
  </nav>
  </div>
  <div class="container">
  <div class="page-header">
  </div>
  </div>
  <div class="container">
  <img class="mapImage img-thumbnail" ng-animate=" "animate" " ng-src="{{mapURL()}}">
  </div>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular.min.js"></script>
  <script src="http://code.angularjs.org/1.2.10/angular-animate.min.js"></script>
  <script src="http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular-resource.min.js"></script>
  <script>
  angular.module("AnimatedMaps", ["ngAnimate"])
  .controller("ClientApp", ["$scope", "$window", "$interpolate", function($scope, $window, $interpolate) {
  "use strict";
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
  $scope.maxValue = [[[max]]];
  /**
  * The ending map dateValue
  * @type {number}
  */
  $scope.minValue = 1;
  /**
  * url template for preloading images
  * @type {string}
  */
  $scope.urlTemplate = $interpolate("choropleth_{{dateValue}}.png");
  /**
  * The map image URL being displayed
  * @type {string}
  */
  $scope.mapURL = function() {
  return $scope.urlTemplate({dateValue: $scope.dateValue});
  }
  /**
  * Increment the date
  */
  $scope.plusValue = function() {
  if ($scope.dateValue < $scope.maxValue)
  $scope.dateValue++;
  }
  /**
  * Decrement the date
  */
  $scope.minusValue = function() {
  if ($scope.dateValue > $scope.minValue)
  $scope.dateValue--;
  }
  /**
  * Start animation traversing through all images in order
  */
  $scope.play = function() {
  if (Number($scope.dateValue) >= Number($scope.maxValue)) {
  $scope.dateValue = $scope.minValue;
  }
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
  "use strict";
  }]);
  </script>
  </body>
  </html>
  '
  
  txt = str_replace(txt, fixed("[[[max]]]"), length(choropleths))
  print("Now writing code to animate all images in 'animated_choropleth.html'.  Please open that file with a browser.")
  write(txt, "animated_choropleth.html")
}