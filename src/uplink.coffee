plex = require 'plex'

module.exports = uplink =

    context: null 

    start: (uri) -> 

        console.log 'uplinking'

        uplink.context = plex.start 

            connect: 

                adaptor: 'socket.io'
                uri: uri


