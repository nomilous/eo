Uplink = require './uplink'

module.exports = class Objective

    configure: (scaffold, opts) -> 

        console.log opts

        if opts.nimbal

            unless typeof @protocol == 'function'

                #
                # default empty protocol 
                #

                @protocol = (When, Then) -> 


            Uplink.start opts.nimbal, opts.secret, @protocol


    edge: (placeholder, nodes) -> 

    hup: ->

    handles: []

    matches: []

