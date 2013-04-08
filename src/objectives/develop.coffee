Objective = require '../objective'

class Develop extends Objective

    monitor: (callback) -> 

        @config.spec = 'spec' unless @config.spec
        @config.src  = 'src' unless @config.src
        @config.dst  = 'lib' unless @config.dst

        path    = @config.path
        specDir = path + '/' + @config.spec
        srcDir  = path + '/' + @config.src
        dstDir  = path + '/' + @config.dst

        @runtime.logger.log

            info: => 'watching':

                paths: [specDir, srcDir]


        @runtime.monitors.directory.watch specDir, (error, file, stat) => 

            if error 
                
                return @runtime.logger.error -> 

                    'failed watch': error: error

            console.log 'changes!', arguments


        @runtime.monitors.directory.watch srcDir, (error, file, stat) => 

            if error

                return @runtime.logger.error -> 

                    'failed watch': error: error

            type = file.match(/\.(\w*)$/)[1]

            @runtime.compilers[type].compile @runtime.logger, 

                src: srcDir
                dst: dstDir
                file: file, (error) -> 

                    unless error

                        console.log 'TODO: call realizer'



    instance: -> 

        class: 'eo:Develop'
        version: 0


    protocol: (When, Then) -> 


if typeof develop == 'undefined'

    develop = new Develop

module.exports = develop
