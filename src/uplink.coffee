plex = require 'plex'

module.exports = uplink =

    context: null 

    start: (uri, secret) -> 

        console.log 'uplinking: ', arguments

        uplink.context = plex.start 

            secret: secret

            connect: 

                adaptor: 'socket.io'
                uri: uri


