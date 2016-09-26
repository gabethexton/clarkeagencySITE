'use strict';

app.directive('caListings', [function () {
    return {
        restrict: "E",
        templateUrl: '/app/shared/listings/listingsView.html'
    };
}]);
