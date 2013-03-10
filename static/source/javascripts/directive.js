/**
 * Created with IntelliJ IDEA.
 * User: trapezoid
 * Date: 2013/03/06
 * Time: 17:04
 * To change this template use File | Settings | File Templates.
 */
(function(){
  //pannya.value('MIU_URL', "ws://" + window.location.host);
  pannya.value('MIU_URL', "ws://localhost:8080");
  pannya.factory('miuService', ['MIU_URL', '$rootScope', function(MIU_URL, $rootScope){
    var miuService = {};
    miuService.$scope = $rootScope.$new(true);
    miuService.connection = new ReconnectingWebSocket(MIU_URL);
    miuService.connection.onopen = function(ev) {
      //miuService.connection.send("!!!testData!!!");
      //miuService.connection.send("!!!testData!!!");
      //miuService.connection.send("!!!testData!!!");
      miuService.connection.send(JSON.stringify({
        'type': 'authRequest',
        'packet': {}
      }));
    };
    miuService.connection.onmessage = function(ev) {
      var data = JSON.parse(ev.data);
      switch (data.type) {
        case "log":
          miuService.$scope.$emit('receiveLog', data.packet);
          break;
        case 'authChallenge':
          break;
      }
    };
    miuService.auth = function(password, challenge) {
      this.connection.send(JSON.stringify({
          'type': 'authResponse',
          'packet': {
            'hash': password + challenge
          }
        }
      ));
    };
    return miuService;
  }]);
})();
