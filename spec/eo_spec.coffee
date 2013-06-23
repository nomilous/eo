require('nez').realize 'Eo', (Eo, test, it, notice, Develop) ->

    CONTEXT  = {
        title: 'TITLE'
        description: 'DESCRIPTION'
    }

    NOTIFIER = 
        use: ->
        event: ->

    FUNCTION = ->


    it 'validates objective config for title', (done) -> 

        try Eo.validate {}
        catch error
            error.should.match /objective\(title, opts, fn\) requires title as string/
            test done

    it 'validates objective config for description', (done) -> 

        try Eo.validate 'title', {}
        catch error
            error.should.match /objective\(title, opts, fn\) requires opts.description as string/
            test done


    it 'validates objective config for function as last arg', (done) -> 

        try Eo.validate 'title', description: 'description'
        catch error
            error.should.match /objective\(title, opts, fn\) requires function as last argument/
            test done


    it 'returns the formatted context', (done) -> 

        Eo.validate( 'title', description: 'description', -> ).should.eql

            title: 'title'
            description: 'description'
            secret: ''

        test done


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

    

