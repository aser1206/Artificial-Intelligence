;;Fuzzy Input set definition
(deftemplate Temperature
    20 115 degrees
    (
        (Cold (65 1) (75 0))
        (Normal (65 0) (75 1) (85 0))
        (Hot (75 0) (85 1))
    )
)

(deftemplate DTemperature
    -20 20 degrees
    (
        (Low (5 1) (10 0))
        (Medium (5 0) (10 1) (15 0))
        (High (10 0) (15 1))
    )
)





;;fuzzify the inputs
(defrule fuzzify
    (crispTemperature ?a)
    (crispDTemperature ?b)
    =>
    (assert (Temperature (?a 0) (?a 1) (?a 0)))
    (assert (DTemperature (?b 0) (?b 1) (?b 0)))
)





;;Cold Temp Low Change
(defrule CL
    (Temperature Cold)
    (DTemperature Low)
    =>
    (assert (goodTemp no))
)

;;Cold Temp Medium Change
(defrule CL
    (Temperature Cold)
    (DTemperature Medium)
    =>
    (assert (goodTemp no))
)

;;Cold Temp High Change
(defrule CL
    (Temperature Cold)
    (DTemperature High)
    =>
    (assert (goodTemp no))
)






;;Normal Temp Low Change
(defrule CL
    (Temperature Normal)
    (DTemperature Low)
    =>
    (assert (goodTemp yes))
)

;;Normal Temp Medium Change
(defrule CL
    (Temperature Normal)
    (DTemperature Medium)
    =>
    (assert (goodTemp yes))
)

;;Normal Temp High Change
(defrule CL
    (Temperature Normal)
    (DTemperature High)
    =>
    (assert (goodTemp no))
)





;;Hot Temp Low Change
(defrule CL
    (Temperature Hot)
    (DTemperature Low)
        =>
    (assert (goodTemp yes))
)

;;Hot Temp Medium Change
(defrule CL
    (Temperature Hot)
    (DTemperature Medium)
    =>
    (assert (goodTemp yes))
)

;;Hot Temp High Change
(defrule CL
    (Temperature Hot)
    (DTemperature High)
    =>
    (assert (goodTemp no))
)





;;Logic Tree
(deffacts startup
    (start))

(defrule has-warranty 
    ?x <- (start)
    =>
    (printout t "Was the floor purchased less than 2 years ago? " crlf)
    (assert (warranty (read)))
    (retract ?x)  
)

;;Warranty
(defrule warranty-expired
    (warranty no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule warranty-not-expired
    (warranty yes)
    =>
    (printout t "Is the house acclimated?" crlf)
    (assert (acclimated (read)))
)

;;Acclimated
(defrule is-not-acclimated
    (warranty yes)
    (acclimated no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule is-acclimated
    (warranty yes)
    (acclimated yes)
    =>
    (printout t "Has the floor been stored for more than 72 hours?" crlf)
    (assert (stored (read)))
)

;;Stored
(defrule is-stored
    (warranty yes)
    (acclimated yes)
    (stored no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule is-not-stored
    (warranty yes)
    (acclimated yes)
    (stored yes)
    =>
    (printout t "Enter current temperature:" crlf)
    (bind  ?response1 (read))
    (assert (crispTemperature ?response1))

    (printout t "Enter average night temperature:" crlf)
    (bind  ?response2(read))
    (assert (nightTemp ?response2))

    (printout t "Enter average day temperature:" crlf)
    (bind  ?response3 (read))
    (assert (dayTemp ?response3))

    ;;calculate average temperature and store in crispDTemperature
    (assert (crispDTemperature (- ?response3 ?response2))))
)

;;Temperature (Fuzzy)
(defrule temperature-bad
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule temperature-good
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    =>
    (printout t "Is there a gap present in the floor or wall?" crlf)
    (assert (gap (read)))
)

;;Gap
(defrule is-not-gap
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap no)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule is-gap
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap yes)
    =>
    (printout t "Are there between 0-4 units of moisture?" crlf)
    (assert (moisture (read)))
)

;;Moisture
(defrule is-moisture
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap yes)
    (moisture no)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule is-not-moisture
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap yes)
    (moisture yes)
    =>
    (printout t "Is there proper underlay?" crlf)
    (assert (underlay (read)))
)

;;Underlay
(defrule is-not-underlay
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap yes)
    (moisture yes)
    (underlay no)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule is-underlay
    (warranty yes)
    (acclimated yes)
    (stored yes)
    (goodTemp yes)
    (gap yes)
    (moisture yes)
    (underlay yes)
    =>
    (printout t "Store Pays." crlf)
)