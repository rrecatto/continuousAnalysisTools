function d=display(r)
    d=[sprintf('\n\t\t\trewardSizeULorMS:\t%3.3g\trewardProbabaility:\t%3.3g',r.rewardSizeULorMS, r.rewardProbability) ...
       ];
   
   %add on the superclass 
    d=[d sprintf('\n\t\treinforcementManager:\t') display(r.reinforcementManager)];