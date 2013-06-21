require('nez').realize 'Develop', (Develop, test, context, should) -> 

    MONITORED = things: {}
    CONTEXT =

        title: 'TITLE'
        description: 'DESCRIPTION'
        tools: 
            monitor: 
                directory: (dir, cb) -> MONITORED.things[dir] = cb
    
    EVENTS = {} 

    NOTIFIER = 
        event: (code, payload) -> EVENTS[code] = payload
        use:   ->
        

    context 'start', (it) -> 

        it 'sends objective::start event', (done) -> 

            Develop.start CONTEXT, NOTIFIER, ->
            EVENTS['objective::start'].should.eql 
                class: 'eo:develop'
                properties: CONTEXT
            test done


    context 'monitor', (it) -> 

        it 'monitors default src and spec directories', (done) -> 

            MONITORED.values = {}
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITORED.things['./src']
                should.exist MONITORED.things['./spec']
                test done

        it 'monitors specified src and spec directory', (done) -> 

            MONITORED.values = {}
            CONTEXT.src = './app'
            CONTEXT.spec = '/dev/darnit'
            Develop.start CONTEXT, NOTIFIER, ->
            
                should.exist MONITORED.things['./app']
                should.exist MONITORED.things['/dev/darnit']
                test done

