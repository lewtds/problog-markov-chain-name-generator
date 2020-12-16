:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module('output/model').

follows3(A, B, A) :- follows(B, A).

fixed_len_sequence(N, L) :-
    length(L, N),
    L = [Head|Rest],
    foldl(follows3, Rest, Head, '__end__').

dfs(Start, Input, Output, 0) :- reverse(Input, Output).
dfs('__end__', Input, Output, _) :- reverse(Input, Output).
dfs(Start, Input, Output, Depth) :-
    Start \= '__end__',
    Depth > 0,
    follows(Start, Next),
    NextDepth is Depth - 1,
    dfs(Next, [Start|Input], Output, NextDepth).

max_len_sequence(N, L) :-
    dfs('__start__', [], [_|L], N).

%evidence(fixed_len_sequence(8, ['__start__'|_])).
%query(fixed_len_sequence(8, ['__start__'|_])).

query(max_len_sequence(20, L)).
