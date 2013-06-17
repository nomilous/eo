eo = (context, notifier, moduleFn) ->

    unless context.module? 

        context.module = require './objectives/develop'

    if typeof context.module == 'string'

        context.module = require context.module

    context.module.start context, notifier, moduleFn



messenger = (msg, next) -> 

    #
    # default console output for eo
    #

    console.log JSON.stringify msg.content, null, 2
    next()


eo.develop     = require './objectives/develop'
eo.messenger   = messenger
module.exports = eo
