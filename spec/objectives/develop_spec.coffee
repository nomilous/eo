require('nez').realize 'Develop', (Develop, test, context, should) -> 

    MONITORED = things: {}
    COMPILED  = things: []
    NOTIFIED  = 
        event: {}
        info: {}


    MONITOR = (notice, dir, cb) -> 
        MONITORED.things[dir] = cb

    COMPILER = (notice, opts, cb) -> 
        COMPILED.things.push arguments
        cb null



    CONTEXT =
        title: 'TITLE'
        description: 'DESCRIPTION'
        tools: 
            monitor: 
                directory: MONITOR
            compiler:
                language: 
                    compile: COMPILER
                        
    

    NOTIFIER = 
        event: (title, payload) -> NOTIFIED.event[title] = payload
        info: 
            bad: (title, payload) -> NOTIFIED.info[title] = payload
        use:   ->
        

    context 'start', (it) -> 

        it 'sends objective::start event', (done) -> 

            Develop.start CONTEXT, NOTIFIER, ->
                NOTIFIED.event['objective::start'].should.eql 
                    class: 'eo:develop'
                    properties: CONTEXT
                test done


    context 'monitor', (it) -> 

        it 'monitors default src and spec directories', (done) -> 

            MONITORED.things = {}
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITORED.things['./src']
                should.exist MONITORED.things['./spec']
                test done

        it 'monitors specified src and spec directory', (done) -> 

            MONITORED.things = {}
            CONTEXT.src = './app'
            CONTEXT.spec = '/dev/darnit'
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITORED.things['./app']
                should.exist MONITORED.things['/dev/darnit']
                test done

    context 'compile', (it) -> 

        CONTEXT.tools.monitor.directory = (notice, dir, cb) -> 

            cb 'changed', './src/file/of/script.language'

        it 'is called from changes in src dir', (done) ->

            CONTEXT.tools.compiler.language.compile = (notice, opts, cb) -> 

                opts.file.should.eql './src/file/of/script.language'
                test done
            
            Develop.start CONTEXT, NOTIFIER, ->


        it 'notifies of compile error', (done) -> 

            CONTEXT.tools.compiler.language.compile = (notice, opts, cb) -> 

                cb new Error 'compile failed'

            NOTIFIER.info.bad = (title, msg) -> 

                msg.error.should.match /compile failed/
                test done

            Develop.start CONTEXT, NOTIFIER, ->


