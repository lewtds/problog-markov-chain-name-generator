:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(assert)).
:- use_module(library(db)).
:- use_module(library(builtin)).

:- csv_load('output/known_transitions.csv', known_transition).
:- csv_load('output/known_starting_states.csv', known_starting_state).

% For every known starting state, generate an annotated disjunction containing all known possible transitions from
% that state with blank probabilities. Those probabilities will be learned with the evidence file.

combine_or(Rest, Term, (Rest; Term)).

compose_disjunctions :-
    forall(known_starting_state(S), compose_disjunction(S)).

compose_disjunction(Start) :-
    write('composing disjunction for '), writeln(Start),
    findall((t("__SENTINEL__")::follows(Start, Other)), known_transition(Start, Other), Terms),
    Terms = [Head | Rest],
    foldl(combine_or, Rest, Head, Disjunction),
    assertz(Disjunction).

:- compose_disjunctions.

query(follows(_,_)).
