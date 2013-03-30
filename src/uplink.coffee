plex = require 'plex'

module.exports = uplink =

    context: null 

    start: (uri, secret, bind, protocol) -> 

        uplink.context = plex.start 

            secret: secret

            connect: 

                adaptor: 'socket.io'
                uri: uri

            protocol: (When, Then) -> 

                #
                # Base Objective binds to the connection for
                # for transmission of edge traversal events.
                #

                bind When, Then

                #
                # Objective implementations bind their own 
                # protocol.
                #

                protocol When, Then

