require('nez').realize 'Objective', (Objective, test, context, should, Uplink) -> 

    context 'as nez objective plugin', (it) ->

        objective = new Objective

        it 'defines configure()', (done) -> 

            objective.configure.should.be.an.instanceof Function
            test done            

        it 'defines edge()', (done) -> 

            objective.edge.should.be.an.instanceof Function
            test done            

        it 'defines hup()', (done) -> 

            objective.hup.should.be.an.instanceof Function
            test done 


        it 'defines handles and matches', (done) -> 

            objective.handles.should.be.an.instanceof Array
            objective.matches.should.be.an.instanceof Array
            test done              

        it 'connects to nimbal as an "Active Objective"', (done) -> 

            #
            # moch uplink starting
            #

            swap = Uplink.start
            Uplink.start = (uri, secret, bind) -> 

                Uplink.start = swap
                uri.should.equal 'UPLINK_URI'
                secret.should.equal 'i1duh'
                bind.should.be.an.instanceof Function
                bind.should.equal objective.bind

                test done

            objective.configure null, nimbal: 'UPLINK_URI', secret: 'i1duh'


        it 'allows the objective to define a protocol', (done, plex) -> 

            #
            # mock a connection...
            #

            swap = plex.start
            plex.start = (opts) -> 

                #
                # ...by calling protocol bind immediately on start
                #    with fake attached send and receive interfaces.
                # 
                #    (this call usually only happens on connect) 
                #

                opts.protocol ( -> 'SUBSCRIBER' ), ( -> 'PUBLISHER')

            protocolBind = false
            objective.protocol = (When, Then) -> 

                When().should.equal 'SUBSCRIBER'
                Then().should.equal 'PUBLISHER'
                protocolBind = true

            objective.configure null, nimbal: 'UPLINK_URI', secret: 'i1duh'

            protocolBind.should.equal true

            #
            # did the objective also bind internally 
            #

            objective.uplink.When().should.equal 'SUBSCRIBER'
            objective.uplink.Then().should.equal 'PUBLISHER' 

            test done
