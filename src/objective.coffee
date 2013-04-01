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
                # Default protocol.
                #

                @protocol = (When, Then) -> 

            unless typeof @instance == 'function'

                #
                # Default instance
                #

                @instance = -> 

                    class: 'eo:Objective'
                    version: 0

            Uplink.start opts.nimbal, opts.secret, @bind


    #
    # Create local bind to PubSub
    #

    uplink: {}
    
    bind: (When, Then) =>

        # 
        # Objective implementations should define 
        # their own protocols.
        #

        @protocol When, Then

        #
        # Local bind for builtin Objective infrastructure
        #

        @uplink.When = When
        @uplink.Then = Then

        When 'register?', (payload) => 

            #
            # respond to node registration
            #

            Then 'register!', 

                _node:
                    Entity:         
                        
                        implements: [
                            { class: 'symbal:Objective', version: 0 }
                        ]

                        #
                        # Objectives should define instance()
                        # to return eg. 
                        # 
                        #  class: <module>:<ClassName>
                        #  version: N
                        #  

                        instance: @instance()


    edge: (placeholder, nodes) -> 

    hup: ->

    handles: []

    matches: []
