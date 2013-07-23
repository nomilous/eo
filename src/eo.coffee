develop = require './objectives/develop'
started = false

messenger = (context) -> 

    unless context.module? 

        return develop.messenger

    if typeof context.module.messenger == 'function'

        return context.module.messanger

    #
    # default console output for eo
    #

    return (msg, next) -> 

        {title} = msg.context

        unless started

            console.log "objective without messenger"
            started = true

        next()

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

    context.module.start context, notice, moduleFn, (task) -> 

        task.then(

            (resolve) -> console.log RESOLVE: resolve
            (reject)  -> console.log REJECT:  reject
            (notify)  -> console.log NOTIFY:  notify

        )


eo.validate    = validate
eo.develop     = develop
eo.messenger   = messenger
module.exports = eo
