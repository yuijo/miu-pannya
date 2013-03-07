/**
 * Created with IntelliJ IDEA.
 * User: trapezoid
 * Date: 2013/03/06
 * Time: 17:04
 * To change this template use File | Settings | File Templates.
 */
(function(){
  var pannya = angular.module('pannya', []);
  pannya.value('MIU_URL', "ws://" + window.location.host);
  pannya.factory('miuService', ['MIU_URL', function(MIU_URL){
    var miuService = {};
    miuService.connection = new WebSocket(MIU_URL);
    return miuService;
  }]);
  pannya.factory('postService', function($http){
    return {
      post: function(message){
        return;
      }
    }
  });

  pannya.directive('room', function factory(){
    return {
      restrict: 'E',
      controller: function($scope, $attrs, $element, postService) {
        var messages = [];
        for (var i = 0; i < 30; i++) {
          messages.push(
            {
              "tag" : "pigchat",
              "time": 0,
              "miu": {
                "network": {
                  "name": "pigchat"
                },
                "type": "text",
                "content": {
                  "room": {"name":"#itokanae"},
                  "user": {"name":"Butapezoid"},
                  "text": "おっぱいをオフショア2"
                }
              }
            }
          );
        }
        $scope.messages = messages;
        $scope.room = {
          'name': "#itokanae",
          'messages': $scope.messages
        };

        $scope.isIconVisible = false;
        $scope.toggleIconVisible = function(){
          $scope.isIconVisible = !$scope.isIconVisible;
        };

        $scope.post = function(){
          postService.post("hogehoge");
        }
      },
      replace: true,
      templateUrl: 'room.html'
      //template: '<input>'
    };
  });
})();
