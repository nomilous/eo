Objective = require '../objective'

class Develop extends Objective

    instance: -> 

        class: 'eo:Develop'
        version: 0


    protocol: (When, Then) -> 


if typeof develop == 'undefined'

    develop = new Develop

module.exports = develop
