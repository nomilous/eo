Objective = require '../objective'

class Develop extends Objective

    monitor: (callback) -> 

        @config.spec = 'spec' unless @config.spec
        @config.src = 'src' unless @config.src

        @runtime.logger.log

            info: => 'watching':

                paths: [@config.spec, @config.src]


    instance: -> 

        class: 'eo:Develop'
        version: 0


    protocol: (When, Then) -> 


if typeof develop == 'undefined'

    develop = new Develop

module.exports = develop
