require('nez').realize 'Eo', (Eo, test, it, notice, Develop) ->

    it 'creates a notifier', (done) -> 

        notice.create = (source, defualtMiddlewareFn) -> 

            source.should.equal 'objective'
            test done

        Eo {}, ->



    it 'defaults the runtime plugin to develop', (done) -> 

        Develop.start = -> test done
        Eo {}, ->

