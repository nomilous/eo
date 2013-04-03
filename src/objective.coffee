module.exports = class Objective

    configure: (scaffold, opts) ->


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
                            { class: 'symbal:Collaborator', version: 0 }
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
