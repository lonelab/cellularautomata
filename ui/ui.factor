USING: kernel namespaces math quotations arrays sequences threads grouping
       opengl opengl.gl colors colors.constants ui ui.gadgets ui.render ui.pens.solid
       ui.gestures accessors cellular ;
IN: cellular.ui

SYMBOL: point-size
SYMBOL: current-rule

TUPLE: cellular-gadget < gadget ;

: <cellular-gadget> ( -- gadget )
    cellular-gadget new
    COLOR: gray21 <solid> >>interior ;

M: cellular-gadget pref-dim* drop { 1366 660 } ;

: draw-point ( y value x -- ) swap t = [ point-size get * swap glVertex2i ] [ 2drop ] if ;

: draw-line ( y line -- ) [ [ dup ] 2dip draw-point ] each-index drop ;

: draw-next ( y line -- y new-line )
    [ draw-line ] 2keep step-wrapped-line [ point-size get + ] dip ;

: draw-times ( y line times -- )
    dup 0 > [ [ draw-next ] dip 1 - draw-times ] [ 3drop ] if ; inline recursive
    
: get-rule ( -- n )
    current-rule get 
    [ current-rule get ] [ 30 dup current-rule set ] if ; 

M: cellular-gadget draw-gadget* ( gadget -- )
    110 current-rule set
    drop 
    get-rule set-rule
    COLOR: white gl-color
    2 point-size set
    point-size get dup glPointSize glLineWidth
    GL_POINTS glBegin
    point-size get 2 /i
    ! 700 start-center 
    700 start-random 
    1000 draw-times
    glEnd
    ;

! press up or down to change rule
cellular-gadget H{
    { T{ key-down f f "UP" }     [ get-rule 1 + current-rule set relayout-1 ] }
    { T{ key-down f f "DOWN" }   [ get-rule 1 - current-rule set relayout-1 ] }
} set-gestures


MAIN-WINDOW: cellular-window { { title "cellular automata" } }
    <cellular-gadget> >>gadgets ;

MAIN: cellular-window
