develop = require './objectives/develop'


validate = (title, opts, objectiveFn) -> 

    context = title: title

    context[key]   = opts[key] for key of opts

    #
    # todo: enforce secret if not listening on localhost
    #
    
    context.secret = '' unless context.secret? 

    unless typeof title == 'string'
        throw new Error 'objective(title, opts, fn) requires title as string'

    unless typeof opts.description == 'string'
        throw new Error 'objective(title, opts, fn) requires opts.description as string'

    unless typeof objectiveFn == 'function'
        throw new Error 'objective(title, opts, fn) requires function as last argument'

    return context


eo = (context, notice, moduleFn) ->

    unless context.module? 

        context.module = develop

    if typeof context.module == 'string'

        context.module = require context.module

    context.module.start context, notice, moduleFn



messenger = (msg, next) -> 

    #
    # default console output for eo
    #

    console.log JSON.stringify msg.content, null, 2
    next()


eo.validate    = validate
eo.develop     = develop
eo.messenger   = messenger
module.exports = eo
