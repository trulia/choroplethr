#' Animate a list of chropleths
#' 
#' Given a list of choropleths, represented as ggplot2 objects
#' \enumerate{
#' \item Save the individual images to the working directory with the naming convention "choropleth_1.png", "choropleth_2.png", etc.
#' \item Write a file called "animated_choropleth.html" which contains a viewer which animates them.
#' }
#'
#' @param choropleths A list of choropleths represented as ggplot2 objects.  Created by, for example, \code{\link{choroplethr}} 
#' or \code{\link{choroplethr_acs}}.
#' @return Nothing.  However, a variable number of files are written to the current working directory.
#' 
#' @keywords choropleth animation
#' 
#' @importFrom ggplot2 ggsave
#' @importFrom stringr str_replace fixed
#' @export
#' @examples
#' \dontrun{
#' data(choroplethr)
#' ?df_president_ts # time series of all US presidential elections 1789-2012
#' 
#' # create a list of choropleths of presidential election results for each year
#' choropleths = list()
#' for (i in 2:ncol(df_president_ts)) {
#'   df           = df_president_ts[, c(1, i)]
#'   colnames(df) = c("region", "value")
#'   title        = paste0("Presidential Election Results: ", colnames(df_president_ts)[i])
#'   choropleths[[i-1]] = choroplethr(df, "state", title=title) 
#' }
#'
#' # set working directory and animate
#' setwd("~/Desktop")
#' choroplethr_animate(choropleths)
#' }
choroplethr_animate = function(choropleths)
{
  stopifnot(is.list(choropleths))
  # stop if not all things are ggplot2 objects
  
  # stop if any of hte files we're going to write already exist in the current directory
  # or alternative just write a emssage to the console saying what you wrote to the filesystem
  
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
  <img class="mapImage" ng-animate=" "animate" " ng-src="choropleth_{{dateValue}}.png">
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
  $scope.maxMaps = {{maxMaps}};
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
  
  txt = str_replace(txt, fixed("{{minMaps}}"), 1)
  txt = str_replace(txt, fixed("{{maxMaps}}"), length(choropleths))
  txt = str_replace(txt, fixed("{{maxMaps}}"), length(choropleths))
  write(txt, "animated_choropleth.html")
}
