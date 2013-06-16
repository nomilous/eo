exports.start = (context, notifier, moduleFn) ->

    notifier.use (msg, next) -> 

        #
        # temporary notifier middleware - for devtime viewing
        #

        console.log JSON.stringify msg.content, null, 2
        next()


    notifier.event 'objective::start', objective: context

    moduleFn()
