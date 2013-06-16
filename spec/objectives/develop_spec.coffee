require('nez').realize 'Develop', (Develop, test, context) -> 

    
    CONTEXT =

        title: 'TITLE'
        description: 'DESCRIPTION'
    
    EVENTS = {} 

    NOTIFIER = 
        event: (code, payload) -> EVENTS[code] = payload
        use:   ->
        

    context 'start', (it) -> 

        it 'sends objective::start event', (done) -> 

            Develop.start CONTEXT, NOTIFIER, ->
            EVENTS['objective::start'].should.eql objective: CONTEXT
            test done

