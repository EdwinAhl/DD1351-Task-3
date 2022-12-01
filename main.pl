% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen, use_module(library(lists)),
    check(T, L, S, [], F).

    % T - The transitions in form of adjacency lists
    % L - The labeling
    % S - Current state
    % U - Currently recorded states
    % F - CTL Formula to check.


% OPERATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Literals
    %check(_, L, S, [], X) :- ...


    % Neg
    %check(_, L, S, [], neg(X)) :- ...


    % And
    %check(T, L, S, [], and(F,G)) :- ...


    % Or
    %check(T, L, S, [], or(F,G)) :- ...


    % AX
    %check(T, L, S, [], ax(X)) :- ...


    % EX
    %check(T, L, S, [], ex(X)) :- ...


    % AG
    %check(T, L, S, [], ag(X)) :- ...


    % EG
    %check(T, L, S, [], eg(X)) :- ...
    

    % EF
    %check(T, L, S, [], ef(X)) :- ...


    % AF
    %check(T, L, S, [], af(X)) :- ...