Objective = require './objective'

if typeof objective == 'undefined' 

    objective = new Objective

module.exports = 

    configure: objective.configure

    edge: objective.edge

    hup: objective.hup

    handles: objective.handles

    matches: objective.matches
