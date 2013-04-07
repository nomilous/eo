require('nez').realize 'Develop', (Develop, test, context) -> 

    context 'as instance of eo:Objective', (it) ->

        it 'defines instance', (done) ->

            Develop.instance().should.eql

                class: 'eo:Develop'
                version: 0

            test done
