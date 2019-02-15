(deffacts startup
    (start))

(defrule is-cold 
    ?x <- (start)
=>
    (printout t "Is it cold? " crlf)
    (assert (cold (read)))
    (retract ?x)  
)

(defrule long-sleeves
    (cold yes)
=>
    (printout t "Wear long sleeves" crlf)
)

(defrule play-sports
    (cold no)
=>
    (printout t "Going to play sports?" crlf)
    (assert (sports (read)))
)

(defrule shoes
    (cold no)
    (sports yes)
=>
    (printout t "Wear some athletic shoes." crlf)
)

(defrule go-party
    (cold no)
    (sports no)
=>
    (printout t "Going to a party?" crlf)
    (assert (party (read)))
)


(defrule is-male
    (cold no)
    (sports no)
    (party yes)
=>
    (printout t "Are you a male?" crlf)
    (assert (male (read)))
)

(defrule watching-tv
    (cold no)
    (sports no)
    (party no)
=>
    (printout t "Are you watching TV?" crlf)
    (assert (tv (read)))
)

(defrule long-pants
    (cold no)
    (sports no)
    (party yes)
    (male yes)
=>
    (printout t "Wear Long Dress Pants" crlf)
)

(defrule wear-dress
    (cold no)
    (sports no)
    (party yes)
    (male no)
=>
    (printout t "Wear a Dress" crlf)
)

(defrule popcorn
    (cold no)
    (sports no)
    (party no)
    (tv yes)
=>
    (printout t "Eat some popcorn" crlf)
)

(defrule go-find-party
    (cold no)
    (sports no)
    (party no)
    (tv no)
=>
    (printout t "You sound bored go find a party" crlf)
)



