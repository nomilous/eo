require('nez').realize 'Eo', (Eo, test, it, should) -> 

    it 'exports a dev objective', (done) -> 

        Eo.dev.should.equal = require '../lib/objectives/dev'
        test done
