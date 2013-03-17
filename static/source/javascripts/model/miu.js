/**
 * Created with IntelliJ IDEA.
 * User: trapezoid
 * Date: 2013/03/14
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */

pannya.model = pannya.model || {};

/**
 *
 * @param params
 * @constructor
 */
pannya.model.MiuPacket = function(params) {
  this.tag = params.tag || null;
  this.time = params.time || null;
  this.room = params.room || null;
};

/**
 * @static
 * @param pannyaPacket
 * @return {pannya.model.MiuPacket}
 */
pannya.model.MiuPacket.parsePannyaServerPacket = function(pannyaPacket) {
  return new pannya.model.MiuPacket();
};