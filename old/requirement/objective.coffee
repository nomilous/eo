Objective = require('nez').linked 'Objective'

Objective

    as: 'a software developer'
    to: 'manage my objectives in progress'
    need: 'an uplink to my home application'

    title: 'nimbal uplink', (spec) -> 

        spec.link 'spec/uplink'

