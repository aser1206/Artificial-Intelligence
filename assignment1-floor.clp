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
    -20 20 changeDegrees
    (
        (Low (5 1) (10 0))
        (Medium (5 0) (10 1) (15 0))
        (High (10 0) (15 1))
    )
)

;;Fuzzy Output set definition
(deftemplate WhoPays
    20 100 payer
    (
        (CP (65 1) (73 0))
        (IP (65 0) (73 1) (80 0))
        (SP (73 0) (80 1))
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

;; defuzzify the outputs
(defrule defuzzify1
    ?f <- (WhoPays ?)
    =>
    (bind ?t (moment-defuzzify ?f))
)






;; FAM rule definition
;;Cold Temp Low Change
(defrule CL
    (Temperature Cold)
    (DTemperature Low)
    =>
    (assert (WhoPays CP))
    (assert (GoodTemp yes))
)

;;Cold Temp Medium Change
(defrule CM
    (Temperature Cold)
    (DTemperature Medium)
    =>
    (assert (WhoPays CP))
    (assert (GoodTemp yes))
)

;;Cold Temp High Change
(defrule CH
    (Temperature Cold)
    (DTemperature High)
    =>
    (assert (WhoPays CP))
    (assert (GoodTemp no))
)

;;Normal Temp Low Change
(defrule NL
    (Temperature Normal)
    (DTemperature Low)
    =>
    (assert (WhoPays IP))
    (assert (GoodTemp no))
)

;;Normal Temp Medium Change
(defrule NM
    (Temperature Normal)
    (DTemperature Medium)
    =>
    (assert (WhoPays IP))
    (assert (GoodTemp yes))
)

;;Normal Temp High Change
(defrule NH
    (Temperature Normal)
    (DTemperature High)
    =>
    (assert (WhoPays IP))
    (assert (GoodTemp yes))
)

;;Hot Temp Low Change
(defrule HL
    (Temperature Hot)
    (DTemperature Low)
        =>
    (assert (WhoPays SP))
    (assert (GoodTemp yes))
)

;;Hot Temp Medium Change
(defrule HM
    (Temperature Hot)
    (DTemperature Medium)
    =>
    (assert (WhoPays SP))
    (assert (GoodTemp no))
)

;;Hot Temp High Change
(defrule HH
    (Temperature Hot)
    (DTemperature High)
    =>
    (assert (WhoPays SP))
    (assert (GoodTemp yes))
)





;;Logic Tree
(defrule has-warranty
    ?i <- (initial-fact)
    =>
    (printout t "Was the floor purchased less than 2 years ago? " crlf)
    (assert (warranty (read)))
    (retract ?i)
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
    (printout t "Is the floor in the house?" crlf)
    (assert (inHouse (read)))
)

;;inHouse
(defrule is-not-inHouse
    (warranty yes)
    (inHouse no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule is-inHouse
    (warranty yes)
    (inHouse yes)
    =>
    (printout t "Has the floor been stored for more than 72 hours?" crlf)
    (assert (stored (read)))
)

;;Stored
(defrule is-stored
    (warranty yes)
    (inHouse yes)
    (stored no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule is-not-stored
    (warranty yes)
    (inHouse yes)
    (stored yes)
    =>
    (printout t "Enter current temperature:" crlf)
    (bind  ?response1 (read))
    (assert (crispTemperature ?response1))

    (printout t "Enter average night temperature:" crlf)
    (bind  ?response2(read))

    (printout t "Enter average day temperature:" crlf)
    (bind  ?response3 (read))

    ;;calculate average temperature and store in crispDTemperature
    (assert (crispDTemperature (- ?response3 ?response2))))
)

;;Temperature (Fuzzy)
(defrule temperature-bad
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp no)
    =>
    (printout t "Customer Pays." crlf)
)

(defrule temperature-good
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    =>
    (printout t "Is there a gap present in the floor or wall?" crlf)
    (assert (gap (read)))
)

;;Gap
(defrule is-not-gap
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap no)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule is-gap
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap yes)
    =>
    (printout t "Is there Moisture on the concrete?" crlf)
    (assert (moisture (read)))
)

;;Moisture
(defrule has-moisture
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap yes)
    (moisture yes)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule has-no-moisture
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap yes)
    (moisture no)
    =>
    (printout t "Is there proper underlay?" crlf)
    (assert (underlay (read)))
)

;;Underlay
(defrule has-no-underlay
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap yes)
    (moisture no)
    (underlay no)
    =>
    (printout t "Installer Pays." crlf)
)

(defrule has-underlay
    (warranty yes)
    (inHouse yes)
    (stored yes)
    (GoodTemp yes)
    (gap yes)
    (moisture no)
    (underlay yes)
    =>
    (printout t "Store Pays." crlf)
)
