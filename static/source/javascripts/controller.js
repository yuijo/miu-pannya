/**
 * Created with IntelliJ IDEA.
 * User: trapezoid
 * Date: 2013/02/22
 * Time: 16:27
 * To change this template use File | Settings | File Templates.
 */
function PannyaController($scope, miuService) {

  $scope.rooms = [];
  var roomsDict = {};
  for (var i = 0; i < 5; i++) {
    var messages = [];
    var roomname = "#itokanae" + i;
    for (var j = 0; j < 30; j++) {
      messages.push(
        {
          "tag": "miu.output.irc.pig",
          "time": 0,
          "miu": {
            "network": {
              "name": "pigchat"
            },
            "type": "text",
            "content": {
              "room": {"name": roomname},
              "user": {"name": "Trapezoid"},
              "text": "" + Math.random() + "おっぱいをオフショア" + j
            }
          }
        }
      );
    }
    var room = {
      'name': roomname,
      'id': roomname + "@pig",
      'tag': "miu.output.irc.pig",
      'network': {
        'name': 'pig'
      },
      'messages': messages
    };
    $scope.rooms.push(room);
    roomsDict[room.id] = room;
  }
  $scope.room = {};//$scope.rooms[0];
  $scope.predicate = 'id';


  $scope.messages = messages;

  $scope.isIconVisible = false;
  $scope.toggleIconVisible = function () {
    $scope.isIconVisible = !$scope.isIconVisible;
  };

  $scope.post = function () {
    postService.post("hogehoge");
  }

  $scope.openRoom = function (id) {
    if (roomsDict.hasOwnProperty(id)) {
      $scope.room = roomsDict[id];
      $scope.front = "room";
    } else {
      $scope.front = "onlyRoomList";
    }
  };
  $scope.openRoom(null);

  $scope.switchView = function () {
    switch ($scope.front) {
      case "room":
        $scope.front = "roomList";
        break;
      case "roomList":
      case "onlyRoomList":
        $scope.front = "room";
        break;
    }
  };

  $scope.say = function() {
    console.log($scope.sayContent);
  }

  miuService.$scope.$on('receiveLog', function (ev, log) {
    console.log(log);
    $scope.$apply(function(){
    var id = log.miu.content.room.name + "@" + log.tag;
    if (!roomsDict.hasOwnProperty(id)){
      roomsDict[id] = {
        'id': id,
        'name': log.miu.content.room.name,
        'tag': log.tag,
        'network': log.miu.network,
        'messages': []
      }
      $scope.rooms.push(roomsDict[id]);
    }

    roomsDict[id].messages.unshift(log);
    });
  });
}