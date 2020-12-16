:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(assert)).
:- use_module(library(db)).

:- csv_load('output/known_transitions.csv', known_transition).
:- csv_load('output/known_starting_states.csv', known_starting_state).


combine_or(Rest, Term, (Rest; Term)).

compose_disjunctions :-
    findall(S, known_starting_state(S), States),
    writeln(States),
    maplist(compose_disjunction, States).

compose_disjunction(Start) :-
    write('composing disjunction for '), writeln(Start),
    findall((t("__SENTINEL__")::follows(Start, Other)), known_transition(Start, Other), Terms),
    Terms = [Head | Rest],
    foldl(combine_or, Rest, Head, Disjunction),
    assertz(Disjunction).

:- compose_disjunctions.

query(follows(_,_)).
