// Generated by CoffeeScript 1.4.0
var Objective, Uplink;

Uplink = require('./uplink');

module.exports = Objective = (function() {

  function Objective() {}

  Objective.prototype.configure = function(scaffold, opts) {
    console.log(opts);
    if (opts.nimbal) {
      if (typeof this.protocol !== 'function') {
        this.protocol = function(When, Then) {};
      }
      return Uplink.start(opts.nimbal, opts.secret, this.protocol);
    }
  };

  Objective.prototype.edge = function(placeholder, nodes) {};

  Objective.prototype.hup = function() {};

  Objective.prototype.handles = [];

  Objective.prototype.matches = [];

  return Objective;

})();