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

    %append([],L,L).
    %append([H|T],L,[H|R]) :- append(T,L,R).

    appendEl(X, [], [X]).
    appendEl(X, [H | T], [H | Y]) :-
               appendEl(X, T, Y).

% OPERATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Neg
    check(_, L, S, U, neg(X)) :- member([S, R], L), not(member(X, R)).


    % And
    check(T, L, S, U, and(F,G)) :- 
        check(T, L, S, [], F),
        check(T, L, S, [], G).


    % Or
    check(T, L, S, U, or(F,G)) :- check(T, L, S, [], F) ; check(T, L, S, [], G).


    % AX
    check(T, L, S, U, ax(X)) :- 
        member([S, AvailableStates], T),

        % Must be at least one input, otherwise foreach will be true with no items.
        not_member(AvailableStates, U, _),
        foreach(
            not_member(AvailableStates, U, NewState),
            check(T, L, NewState, [], X)
        ).
    

    % EX
    check(T, L, S, U, ex(X)) :- 
        % Find the available next states
        member([S, AvailableStates], T),

        % Generate an available state
        not_member(AvailableStates, U, NewState), 

        % Check X in the new state
        check(T, L, NewState, [], X).

    % AG
    check(T, L, S, U, ag(X)) :- 
        % Check current state
        check(T, L, S, [], X),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),
        member([S, AvailableStates], T),

        % Go throgh all AvailableStates 
        foreach(
            not_member(AvailableStates, U, NewState),
            check(T, L, NewState, RecordedStates, ag(X))
        ),
        % Otherwise infinite results
        !.

    % Base case for eg
    check(T, L, S, U, eg(X)) :-
        % when you can loop back to a working state
        member([S, AvailableStates], T),
        appendEl(S, U, RecordedStates),
        member(RecordedState, RecordedStates),
        member(RecordedState, AvailableStates),
        check(T, L, S, [], X);

        % Or no way to go
        member([S, AvailableStates2], T),
        not(not_member(AvailableStates2, U, _)),
        check(T, L, S, [], X).

    % EG
    check(T, L, S, U, eg(X)) :- 
        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Generate an available state
        not_member(AvailableStates, U, NewState),

        % Either continue checking all states for eg
        check(T, L, S, [], X),

        check(T, L, NewState, RecordedStates, eg(X)), 
        % Prevent running multiple times
        !.

    % EF
    check(T, L, S, U, ef(X)) :-     
        % Check X in the current state
        check(T, L, S, [], X);

        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Generate an available state
        not_member(AvailableStates, U, NewState),

        check(T, L, NewState, RecordedStates, ef(X)),
        % Prevent running multiple times
        !.

    % AF
    check(T, L, S, U, af(X)) :-
        check(T, L, S, [], X);

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),
        member([S, AvailableStates], T),

        % Disallow looping back to a false state
        % AF is false if a false state can be looped. 
        not(member(S, AvailableStates)),

        % Must be a next state to do a for loop.
        not_member(AvailableStates, U, _),

        foreach(
            not_member(AvailableStates, U, NewState),
            check(T, L, NewState, RecordedStates, af(X))
        ).


    % Literals
    check(_, L, S, U, X) :- member([S, R], L), member(X, R).