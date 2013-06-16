require('nez').realize 'Eo', (Eo, test, it, notice, Develop) ->

    CONTEXT  = {
        title: 'TITLE'
        description: 'DESCRIPTION'
    }

    NOTIFIER = 
        use: ->
        event: ->

    FUNCTION = ->


    it 'creates a notifier', (done) -> 

        spy = notice.create
        notice.create = (source, defualtMiddlewareFn) -> 

            notice.create = spy
            source.should.equal 'objective'
            test done
            NOTIFIER


        Eo {}, ->


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
            notifier.info.should.be.an.instanceof Function
            moduleFn.should.equal FUNCTION
            test done

        Eo CONTEXT, FUNCTION

    

