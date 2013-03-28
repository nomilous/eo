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

            swap = Uplink.start
            Uplink.start = (uri, secret) -> 

                Uplink.start = swap
                uri.should.equal 'UPLINK_URI'
                secret.should.equal 'i1duh'
                test done

            objective.configure null, nimbal: 'UPLINK_URI', secret: 'i1duh'
