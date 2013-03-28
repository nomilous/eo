Uplink = require './uplink'

module.exports = class Objective

    configure: (scaffold, opts) -> 

        console.log opts

        if opts.nimbal

            Uplink.start opts.nimbal, opts.secret



    edge: (placeholder, nodes) -> 

    hup: ->

    handles: []

    matches: []

