notice         = require 'notice'
module.exports = (context, moduleFn) ->

    #
    # create messenger source
    #

    notifier = notice.create 'objective', (msg, next) -> next()

    unless context.runtime? 

        context.runtime = require './objectives/develop'

    context.runtime.start context, notifier, moduleFn
