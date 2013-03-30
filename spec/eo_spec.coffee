require('nez').realize 'Eo', (Eo, test, it, should) -> 

    it 'exports a dev objective', (done) -> 

        Eo.Develop.should.equal = require '../lib/objectives/develop'
        test done
