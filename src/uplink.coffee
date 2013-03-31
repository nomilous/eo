plex = require 'plex'

module.exports = uplink =

    context: null 

    start: (uri, secret, bind) -> 

        uplink.context = plex.start 

            secret: secret

            connect: 

                adaptor: 'socket.io'
                uri: uri

            protocol: bind

