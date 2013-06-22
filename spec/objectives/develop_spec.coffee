require('nez').realize 'Develop', (Develop, test, context, should) -> 

    MONITOR = things: {}
    COMPILE = things: []
    NOTIFY  = 
        event: {}
        info: {}


    CONTEXT =
        title: 'TITLE'
        description: 'DESCRIPTION'
        tools: 
            monitor: 
                directory: (notice, dir, cb) -> MONITOR.things[dir] = cb
            compiler:
                language: 
                    compile: (notice, opts, cb) -> 
                        COMPILE.things.push arguments
                        cb null
                        
    

    NOTIFIER = 
        event: (title, payload) -> NOTIFY.event[title] = payload
        info: 
            bad: (title, payload) -> NOTIFY.info[title] = payload
        use:   ->
        

    context 'start', (it) -> 

        it 'sends objective::start event', (done) -> 

            Develop.start CONTEXT, NOTIFIER, ->
            NOTIFY.event['objective::start'].should.eql 
                class: 'eo:develop'
                properties: CONTEXT
            test done


    context 'monitor', (it) -> 

        it 'monitors default src and spec directories', (done) -> 

            MONITOR.values = {}
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITOR.things['./src']
                should.exist MONITOR.things['./spec']
                test done

        it 'monitors specified src and spec directory', (done) -> 

            MONITOR.values = {}
            CONTEXT.src = './app'
            CONTEXT.spec = '/dev/darnit'
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITOR.things['./app']
                should.exist MONITOR.things['/dev/darnit']
                test done

    context 'compile', (it) -> 

        it 'is called from changes in src dir', (done) ->

            MONITOR.things = {}
            COMPILE.things  = []
            CONTEXT.lib = 'The lips of time'
            CONTEXT.src = 'the fountain head'
            
            Develop.start CONTEXT, NOTIFIER, ->

                #
                # call a change into the src monitor
                #

                MONITOR.things['the fountain head'](null, '/file/of/script.language')
                setTimeout (-> 

                    #
                    # compiled the file
                    #

                    COMPILE.things[0]['1'].file.should.equal '/file/of/script.language'
                    test done

                ), 10
                

