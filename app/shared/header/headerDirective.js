'use strict';

app.directive('caHeader', [function () {
    return {
        restrict: "E",
        templateUrl: '/app/shared/header/headerView.html'
    };
}]);
