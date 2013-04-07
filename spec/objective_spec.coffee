require('nez').realize 'Objective', (Objective, test, context, should) -> 

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


        it 'allows the objective to define a protocol', (done) -> 


            protocolBind = false
            objective.protocol = (When, Then) -> 

                When().should.equal 'SUBSCRIBER'
                Then().should.equal 'PUBLISHER'
                protocolBind = true

            objective.bind ( -> 'SUBSCRIBER' ), ( -> 'PUBLISHER')

            protocolBind.should.equal true

            #
            # did the objective also bind internally 
            #

            objective.uplink.When().should.equal 'SUBSCRIBER'
            objective.uplink.Then().should.equal 'PUBLISHER' 

            test done

        it 'defines a monitor loop', (done) -> 

            objective.configure logger: warn: (msgFn) -> 

                msgFn().should.equal 'plugin did not override Objective.monitor()'
                test done

            objective.monitor (error, event) ->
