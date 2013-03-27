require('nez').realize 'Uplink', (Uplink, test, context) -> 

    context 'uplink to nimbal', (it) -> 


        it 'uplinks to a specified uri', (done, plex) ->

            plex.start = (opts) ->

                opts.connect.adaptor.should.equal 'socket.io'
                opts.connect.uri.should.equal 'URI'
                test done


            Uplink.start 'URI'


          



    context 'downlink to spec runs', (it) -> 