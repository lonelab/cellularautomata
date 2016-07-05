! Copyright (C) 2016 Lonelabs 
! See http://factorcode.org/license.txt for BSD license.
USING: bit-arrays kernel sequences sequences.private math math.functions grouping accessors
namespaces arrays random ;
IN: cellular

SYMBOL: rule

! rules are encoded as follows:
! PATTERN:        | 111 | 110 | 101 | 100 | 011 | 010 | 001 | 000 |
! COLOR OF CELL : |  0  |  1 |   1  |  0  |  1  |  1  |  1  |  0  |
! the above is rule 110 i.e 01101110 is a binary encoding for the
! number 110 

: create-rule ( n -- bitarray ) 8 swap integer>bit-array resize  ; 
: pattern>state ( ?{_a_b_c} -- state ) >bit-array bit-array>integer rule get nth ;

: cap-line ( line -- 0-line-0 ) ?{ f } prepend ?{ f } append >bit-array ;
: wrap-line ( line -- 0-line-0 ) dup last 1array swap dup first 1array append append >bit-array ;

: (step-line) ( line -- new-line ) 3 <clumps> [ pattern>state ] ?{ } map-as ;

: step-capped-line ( line -- new-line ) cap-line (step-line) ;
: step-wrapped-line ( line -- new-line ) wrap-line (step-line) ;

: start-random ( length -- bit-array ) random-bits integer>bit-array ;
: start-center ( length -- bit-array ) 1 over 2 /i shift integer>bit-array resize ;

: set-rule ( n -- ) create-rule rule set ;


! The below 
