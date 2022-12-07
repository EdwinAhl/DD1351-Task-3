% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen, use_module(library(lists)),
    check(T, L, S, [], F).

    % T - The transitions in form of adjacency lists
    % L - The labeling
    % S - Current state
    % U - Currently recorded states
    % F - CTL Formula to check.

% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % A - The list of available states
    % B - The list of blacklisted states
    % C - The result

    not_member(Available, Blacklist, A) :- member(A, Available), not(member(A, Blacklist)).

    append([],L,L).
    append([H|T],L,[H|R]) :- append(T,L,R).

    appendEl(X, [], [X]).
    appendEl(X, [H | T], [H | Y]) :-
               appendEl(X, T, Y).

% OPERATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Neg
    check(_, L, S, U, neg(X)) :- member([S, R], L), not(member(X, R)).


    % And
    check(T, L, S, U, and(F,G)) :- check(T, L, S, U, F), check(T, L, S, U, G).


    % Or
    check(T, L, S, U, or(F,G)) :- check(T, L, S, U, F) ; check(T, L, S, U, G).


    % AX
    %check(T, L, S, U, ax(X)) :- ...


    % EX
    check(T, L, S, U, ex(X)) :- 
        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Generate an available state
        not_member(AvailableStates, U, NewState), 

        % Check X in the new state
        check(T, L, NewState, RecordedStates, X).


    % AG
    %check(T, L, S, U, ag(X)) :- ...


    % EG
    %check(T, L, S, U, eg(X)) :- ...
    

    % EF
    %check(T, L, S, U, ef(X)) :- ...


    % AF
    %check(T, L, S, U, af(X)) :- ...


    % Literals
    check(_, L, S, U, X) :- member([S, R], L), member(X, R).