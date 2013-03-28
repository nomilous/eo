Uplink = require './uplink'

module.exports = class Objective

    uplink: null

    configure: (scaffold, opts) -> 

        console.log opts

        if opts.nimbal

            Uplink.start opts.nimbal

            

    edge: (placeholder, nodes) -> 

    hup: ->

    handles: []

    matches: []

