nodefncall = require('when/node/function').call
sequence   = require('when/sequence')


start = (context, notice, moduleFn) ->

    #
    # message middleware - to/fro nimbal, later...
    # 

    notice.use (msg, next) -> next()

    #
    # develop env defaults
    #

    context.spec  = './spec' unless context.spec? 
    context.lib   = './lib'  unless context.lib?
    context.src   = './src'  unless context.src?

    #
    # initialize develop objective
    #

    context.tools.monitor.directory notice, context.src,  (placeholder, file, stat) -> 

        #
        # src file changed, prep compiler
        #

        ext = file.match(/\.(\w*)$/)[1]

        switch ext

            when 'coffee', 'litcoffee'

                compile    = context.tools.compiler.coffee.compile
                ensureSpec = context.tools.compiler.coffee.ensureSpec

            else 

                try compile    = context.tools.compiler[ext].compile
                try ensureSpec = context.tools.compiler[ext].ensureSpec


        compile    ||= (notice, opts, cb) -> cb null
        ensureSpec ||= (notice, opts, cb) -> cb null

        opts = 

            file: file
            spec: context.spec
            dst:  context.lib
            src:  context.src

        #
        # compile and ensure present (create default) spec file
        #

        done = sequence [

            -> nodefncall compile,    notice, opts
            -> nodefncall ensureSpec, notice, opts

        ]

        done.then(

            (res) -> 

                #
                # compiled success
                # send task to the corresponding realizer
                # 

                specfile = res[1]
                return unless specfile?
                realizer = id: specfile
                context.realizers.task 'run spec', context, notice, realizer

            (err) -> notice.info.bad 'compile error', error: err

        )

    context.tools.monitor.directory notice, context.spec, (placeholder, file, stat) -> 

        realizer = id: file
        context.realizers.task 'run spec', context, notice, realizer

    #
    # notify and start
    #

    notice.event 'objective::start', 
        class: 'eo:develop'
        properties: context


    #
    # call the external objective loop
    # (args under consideration)
    # 

    moduleFn()





exports.start = start
