notice         = require 'notice'
module.exports = (context, moduleFn) ->

    unless context.module? 

        context.module = require './objectives/develop'

    if typeof context.module == 'string'

        context.module = require context.module

    notifier = notice.create 'objective', context.module.messenger || (msg, next) -> next()

    context.module.start context, notifier, moduleFn
