'use strict';

app.controller('controller',['$http','$window',function($http, $window){
  var vm = this;

  vm.sessionStorage = $window.sessionStorage;

  vm.post = function(username, password, firstname, lastname, displayname, title, phone, email, bio){
    $http.post('https://clarkeagency.herokuapp.com/auth/signup',{
        username:username,
        password:password,
        firstname:firstname,
        lastname:lastname,
        displayname:displayname,
        title:title,
        phone:phone,
        email:email,
        bio:bio
    })

    .then(function(response){
      console.log(response);
      // TODO: log response id here and maybe store in sessionStorage
      vm.message = "New Agent successfully created.";

    })
    .catch(function(err){
      console.log(err);
      // TODO: present better error handling
      vm.message = "Failed to create New Agent";
    });
};

}]);
