require('nez').realize 'Develop', (Develop, test, context) -> 

    context 'as instance of eo:Objective', (it) ->

        it 'defines instance', (done) ->

            Develop.instance().should.eql

                class: 'eo:Develop'
                version: 0

            test done

        it 'monitors spec and src directories', (done) -> 

            watches = []

            Develop.config =
                path: '/path/to/module/repo' 
                spec: 'spec'
                src: 'src'
            Develop.runtime = 
                logger: log: -> 
                monitors: directory: watch: (path, callback) ->
                    watches.push path
 
            Develop.monitor()
            watches.should.eql [

                '/path/to/module/repo/spec'
                '/path/to/module/repo/src'

            ]
            test done
