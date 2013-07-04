nodefncall = require('when/node/function').call
sequence   = require('when/sequence')
colors     = require 'colors'

messenger = (msg, next) -> 

    {title, type, tenor} = msg.context

    switch title

        when 'objective::start' 

            output = "\n" 
            for key of msg.properties
                continue unless typeof msg.properties[key] == 'string'
                continue if key == 'secret'
                if msg.properties[key].match /\n/
                    output += "(#{key})\n#{msg.properties[key].bold}\n"
                else 
                    output += "(#{key}) #{msg.properties[key].bold}\n"

            console.log output

        when 'missing or broken realizer'

            console.log "[#{msg.title}]".red, msg.description.bold

        else 

            console.log "[#{msg.title}]", msg.description

    next()


getCompiler = (context, file) ->

    ext = file.match(/\.(\w*)$/)[1]

    switch ext

        when 'coffee', 'litcoffee'

            compiler   = context.tools.compiler.coffee.compile
            ensureSpec = context.tools.compiler.coffee.ensureSpec

        else 

            try compiler   = context.tools.compiler[ext].compile
            try ensureSpec = context.tools.compiler[ext].ensureSpec

    compiler   ||= (notice, opts, cb) -> cb null
    ensureSpec ||= (notice, opts, cb) -> cb null

    return {
        compiler:   compiler
        ensureSpec: ensureSpec
    }



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

        {compiler, ensureSpec} = getCompiler context, file

        opts = 

            file: file
            spec: context.spec
            dst:  context.lib
            src:  context.src

        #
        # compile and ensure present (create default) spec file
        #

        done = sequence [

            -> nodefncall compiler,    notice, opts
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
                
                context.realizers.task 'spec run', 

                    id:     specfile
                    script: specfile

            (err) -> notice.info.bad 'compile error', error: err

        )

    context.tools.monitor.directory notice, context.spec, (placeholder, file, stat) -> 

        #
        # spec file changed, 
        # ensure it compiles
        # 

        {compiler, ensureSpec} = getCompiler context, file

        compiler notice, { 
            
            file: file
            src:  context.spec

        }, (error, result) -> 

            return if error?

            context.realizers.task 'spec run', 

                id:     file
                script: file


    #
    # notify and start
    #

    notice.event 'objective::start', 

        class: 'eo:develop'
        properties: context
                    #
                    # TODO: trim this 
                    #       - is local runtime context
                    #       - should be summary for remote's notion of context
                    #


    #
    # call the external objective loop
    # (args under consideration)
    # 

    moduleFn()





exports.start     = start
exports.messenger = messenger
