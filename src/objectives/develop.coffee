Objective = require '../objective'

class Develop extends Objective

    monitor: (callback) -> 

        @config.spec = 'spec' unless @config.spec
        @config.src = 'src' unless @config.src

        specDir = @config.path + '/' + @config.spec
        srcDir = @config.path + '/' + @config.src

        @runtime.logger.log

            info: => 'watching':

                paths: [specDir, srcDir]

        @runtime.monitors.directory.watch specDir, (error, file, stat) -> 

            console.log 'changes!', arguments

        @runtime.monitors.directory.watch srcDir, (error, file, stat) -> 

            console.log 'changes!', arguments




    instance: -> 

        class: 'eo:Develop'
        version: 0


    protocol: (When, Then) -> 


if typeof develop == 'undefined'

    develop = new Develop

module.exports = develop
