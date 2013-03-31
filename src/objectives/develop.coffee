Objective = require '../objective'

class Develop extends Objective

    instance: -> 

        class: 'eo:Develop'
        version: 0

    protocol: (When, Then) -> 


if typeof dev == 'undefined'

    dev = new Develop

module.exports = dev
