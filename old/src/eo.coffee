module.exports = 
    
    #
    # **Export:** [Objective](objective.html)
    # **Inject:** `eo:Objective`
    # 
    # This is the base class for defining an Objective
    #    

    Objective: require './objective'


    #
    # **Export:** [Develop](objectives/develop.html)
    # **Inject:** `eo:Develop`
    # **Uplink:** `nimbal:Server`
    # 
    # Software Development Objective
    # 

    Develop: require './objectives/develop'
