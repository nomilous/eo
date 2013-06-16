notice         = require 'notice'
module.exports = (context, fn) ->

    #
    # create messenger source
    #

    notifier = notice.create 'objective', (msg, next) -> next()

    unless context.runtime? 

        context.runtime = require './objectives/develop'

    context.runtime.start notifier, context, fn
