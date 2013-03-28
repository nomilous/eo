Objective = require '../objective'

class Dev extends Objective


    protocol: (When, Then) -> 

        When 'register:req', (payload) -> 

            #
            # received a registration request,
            # send the response
            # 

            Then 'register:res'

                todo: 'send' 
                the:  'objective' 
                meta: 'data'
                to:   'nimbal'



if typeof dev == 'undefined'

    dev = new Dev

module.exports = dev
