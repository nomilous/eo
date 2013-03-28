plex = require 'plex'

module.exports = uplink =

    context: null 

    start: (uri, secret, protocol) -> 

        uplink.context = plex.start 

            secret: secret

            connect: 

                adaptor: 'socket.io'
                uri: uri

            protocol: protocol
