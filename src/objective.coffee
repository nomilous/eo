Uplink = require './uplink'

module.exports = class Objective

    configure: (scaffold, opts) -> 

        if opts.nimbal

            #
            # Uplink this objective to a Nimbal server instance
            # 
            # This option is activated when the objective specifies
            # the config key(s): 
            # 
            #   nimbal: <uri>
            #   secret: <optional_secret>
            # 
            # 
            #

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

