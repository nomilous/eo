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
    # notify and start
    #

    notifier.event 'objective::start', 
        class: 'eo:develop'
        properties: context

    moduleFn()


messenger = (msg, next) -> 

    #
    # default console output for eo::develop
    #

    console.log JSON.stringify msg.content, null, 2
    next()



exports.start     = start
exports.messenger = messenger
