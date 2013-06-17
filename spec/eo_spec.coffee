require('nez').realize 'Eo', (Eo, test, it, notice, Develop) ->

    CONTEXT  = {
        title: 'TITLE'
        description: 'DESCRIPTION'
    }

    NOTIFIER = 
        use: ->
        event: ->

    FUNCTION = ->


    it 'exports objectives', (done) -> 

        Eo.develop.should.equal Develop
        test done


    it 'defaults the runtime plugin to develop', (done) -> 

        spy = Develop.start
        Develop.start = -> 
            Develop.start = spy
            test done
        Eo {}, ->


    it 'starts the runtime with context, notifier and moduleFn', (done) -> 

        spy = Develop.start 
        Develop.start = (context, notifier, moduleFn) ->  
            Develop.start = spy
            context.should.equal CONTEXT
            notifier.should.equal NOTIFIER
            moduleFn.should.equal FUNCTION
            test done

        Eo CONTEXT, NOTIFIER, FUNCTION

    

