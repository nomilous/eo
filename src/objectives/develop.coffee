nodefncall = require('when/node/function').call
fs         = require 'fs'
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

getUUID = (file) -> 
    
    try 
        content = fs.readFileSync( file ).toString()
        uuid = content.match(/###\sREALIZER\s(.*)?\s###/)[1]
        return uuid

    catch error
        return file

start = (context, notice, moduleFn, taskCallback) ->

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

            -> nodefncall compiler,   notice, opts
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

                uuid = getUUID specfile

                taskCallback context.realizers.start

                    #
                    # realizer spawn parameters
                    # -------------------------
                    # 
                    # * providing the realizer collection with a script (filename, [[uri later?]])
                    #   will result in the spawning of the realizer (as child process) if not
                    #   already spawned
                    # 
                    # 

                    uuid:     uuid
                    script:   specfile

                    #
                    # plugin parameters
                    # -----------------
                    #
                    # * configures the module::class::function that will
                    #   perform the services/runtime injection into the 
                    #   realizer loop
                    # 

                    module:   'ipso'
                    class:    'spec'
                    function: 'run'

            (err) -> notice.info.bad 'compile error', error: err

        )

    context.tools.monitor.directory notice, context.spec, (placeholder, file, stat) -> 

        #
        # spec file changed, 
        # ensure it compiles
        # 

        {compiler, ensureSpec} = getCompiler context, file

        opts = 
            file: file
            src:  context.spec
            spec: context.spec

        done = sequence [

            -> nodefncall compiler,   notice, opts
            -> nodefncall ensureSpec, notice, opts

        ]

        done.then(

            (res) -> 

                uuid = getUUID file

                taskCallback context.realizers.start

                    uuid:     uuid
                    script:   file

                    module:   'ipso'
                    class:    'spec'
                    function: 'run'

            (err) -> notice.info.bad 'compile error', error: err

        )


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
