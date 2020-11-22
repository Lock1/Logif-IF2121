width(51).
height(25).
:- dynamic(position/2).
:- dynamic(shop/2).
:- dynamic(quest/2).
:- dynamic(dragon/2).
:- dynamic(playerLocation/2).

/*Random dragon and shop*/
setInitialMap :-
    randomize,
    width(W),
    height(H),
    random(40,W,Absis1),
    random(20,H,Ordinat1),
    random(1,5,Absis2),
    random(1,5,Ordinat2),
    asserta(dragon(Absis1, Ordinat1)),
    asserta(playerLocation(Absis2, Ordinat2)),
    setQuest(3),
    setShop(3).

setQuest(X) :-
    X is 0;
    randomize,
    width(W),
    height(H),
    random(1, W, Absis),
    random(1, H, Ordinat),
    asserta(quest(Absis, Ordinat)),
    X2 is X-1,
    setQuest(X2),!.

setShop(X) :-
    X is 0;
    randomize,
    width(W),
    height(H),
    random(1, W, Absis),
    random(1, H, Ordinat),
    asserta(shop(Absis, Ordinat)),
    X2 is X-1,
    setShop(X2),!.

setMap(X,Y) :- /*Draw Right Border*/
    height(H),
    width(W),
    (
    X =:= W+1,
    Y =< H+1,
    (Y is 0,write('╗'),nl,!;
    Y is H+1,write('╝'),nl,!;
    mod(Y,2) =:= 0,write('┨'),nl,!;
    write('┃'),nl,!
    ),
    Y2 is Y+1,
    setMap(0, Y2),!;

    /*Draw Left Border*/
    X =:= 0,
    Y =< H+1,
    (Y is 0,write('╔'),!;
    Y is H+1,write('╚'),!;
    mod(Y,2) =:= 0,write('┠'),!;
    write('┃'),!
    ),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw Upper Border*/
    X > 0,
    X < W+1,
    Y =:= 0,
    (mod(X,4) =:= 0,write('╤'),!;
    write('═')),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw Bottom Border*/
    X > 0,
    X < W + 1,
    Y =:= H+1,
    (mod(X,4) =:= 0,write('╧'),!;
    write('═')),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw Dragon*/
    X > 0,
    X < W+1,
    Y > 0,
    Y < H+1,
    dragon(X, Y), !,
    write('D'),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw quest*/
    X > 0,
    X < W+1,
    Y > 0,
    Y < H+1,
    quest(X, Y), !,
    write('Q'),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw shop*/
    X > 0,
    X < W+1,
    Y > 0,
    Y < H+1,
    shop(X, Y), !,
    write('S'),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw Player*/
    X > 0,
    X < W+1,
    Y > 0,
    Y < H+1,
    playerLocation(X, Y), !,
    write('@'),
    X2 is X+1,
    setMap(X2, Y),!;

    /*Draw Empty*/
    X > 0,
    X < W+1,
    Y> 0,
    Y< H+1,
    % write('□'),
    % write('•'),
    % write('·'),
    (mod(X,4) =:= 0,mod(Y,2) =:= 0,write('┼'),!;
    mod(X,4) =:= 0,write('│'),!;
    mod(Y,2) =:= 0,write('─'),!;
    write(' '),!),
    X2 is X+1,
    setMap(X2, Y),!

    ).


map :-
    write('\33\[37m\33\[1m'),
    flush_output,
    setMap(0,0), !.
