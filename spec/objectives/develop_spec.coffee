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
        realizers: task: ->
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

        CONTEXT.src = './src'
        CONTEXT.tools.monitor.directory = (notice, dir, cb) -> 

            if dir.match /src/
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


        it 'ensures corresponding spec file / created default', (done) -> 

            CONTEXT.tools.compiler.language.compile = (notice, opts, cb) -> cb null
            CONTEXT.tools.compiler.language.ensureSpec = (notice, opts, cb) -> test done
            Develop.start CONTEXT, NOTIFIER, ->


        it 'issues task to realizer on compile success', (done) -> 

            CONTEXT.realizers.task = -> 
            CONTEXT.tools.compiler.language.compile =    (notice, opts, cb) -> cb null
            CONTEXT.tools.compiler.language.ensureSpec = (notice, opts, cb) -> cb null, './spec/file1_spec'
            CONTEXT.realizers.task = (title, realizer) -> 

                realizer.id.should.equal './spec/file1_spec'
                CONTEXT.realizers.task = ->
                test done

            Develop.start CONTEXT, NOTIFIER, -> 


        # it 'does not call the realizer if the spec was just created', (done) -> 

        #     #
        #     # ensureSpec callsback with no specfile name if it just created the specfile
        #     #
        #     # - this prevents the realizer running the spec twice 
        #     #   (for the src change and then for the spec create)
        #     # 

        #     CONTEXT.tools.compiler.language.compile =    (notice, opts, cb) -> cb null
        #     CONTEXT.tools.compiler.language.ensureSpec = (notice, opts, cb) -> cb null #, './spec/file_spec'

        #     Develop.start CONTEXT, NOTIFIER, -> 

        #     setTimeout (->

        #         console.log RAN_REALIZER

        #     ), 10

    context 'spec', (it) -> 

        it 'issues task to realizer on spec change', (done) -> 

            CONTEXT.tools.monitor.directory = (notice, dir, cb) -> 

                if dir.match /spec/
                    cb 'changed', './spec/file_spec'

            CONTEXT.realizers.task = (title, context) -> 

                title.should.equal 'run'
                context.should.eql 
                    id:     './spec/file1_spec'
                    script: './spec/file1_spec'
                    module: 'ipso'
                    class: 'spec'
                    function: 'run'

                test done

            Develop.start CONTEXT, NOTIFIER, -> 







    