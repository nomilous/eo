start = (context, notifier, moduleFn) ->

    #
    # message middleware - to/fro nimbal, later...
    # 

    notifier.use (msg, next) -> next()

    #
    # develop env defaults
    #

    context.spec  = './spec' unless context.spec? 
    context.lib   = './lib'  unless context.lib?
    context.src   = './src'  unless context.src?

    #
    # initialize develop objective
    #

    context.tools.monitor.directory context.src,  (placeholder, file, stat) -> 

        #
        # src file changed
        #

        ext = file.match(/\.(\w*)$/)[1]

        switch ext

            when 'coffee', 'litcoffee'

                compile = context.tools.compiler.coffee.compile

            else 

                try compile = context.tools.compiler[ext].compile 


        compile ||= -> console.log 'no compiler for', file
        compile

            dst: context.lib
            src: context.src
            file: file, (error) -> 




    context.tools.monitor.directory context.spec, (placeholder, file, stat) -> 

    #
    # notify and start
    #

    notifier.event 'objective::start', 
        class: 'eo:develop'
        properties: context


    #
    # call the external objective loop
    # (args under consideration)
    # 

    moduleFn()




exports.start = start
