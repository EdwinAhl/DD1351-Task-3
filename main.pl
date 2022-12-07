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
    check(T, L, S, U, and(F,G)) :- check(T, L, S, U, F), check(T, L, S, U, G).


    % Or
    check(T, L, S, U, or(F,G)) :- check(T, L, S, U, F) ; check(T, L, S, U, G).


    % AX
    check(T, L, S, U, ax(X)) :- 
        member([S, AvailableStates], T),
        foreach(not_member(AvailableStates, U, NewState), check(T, L, NewState, U, X)).
    

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
    check(T, L, S, U, ag(X)) :- 
        check(T, L, S, U, X),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),
        member([S, AvailableStates], T),

        foreach(
            not_member(AvailableStates, U, NewState),
            check(T, L, NewState, RecordedStates, ag(X))
        ).


    % EG
    check(T, L, S, U, eg(X)) :- 
        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Generate an available state
        not_member(AvailableStates, U, NewState),

        % Either continue checking all states for eg
        check(T, L, NewState, RecordedStates, eg(X));

        % If the current state is correct then go to eg
        check(T, L, S, U, X),
        % Eg basically keeps checking that a path is always valid.

        eg(T, L, S, [], X).

    % Base case for eg
    eg(T, L, S, U, X) :-
        % when you can loop back to a working state
        member([S, AvailableStates], T),
        appendEl(S, U, RecordedStates),
        member(RecordedState, RecordedStates),
        member(RecordedState, AvailableStates),
        check(T, L, S, [], X);

        % Or no way to go
        member([S, AvailableStates2], T),
        not(not_member(AvailableStates2, U, _)).

    % When the EG check is working.
    eg(T, L, S, U, X) :-
        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Current path is valid
        check(T, L, S, U, X),

        not_member(AvailableStates, U, NewState),

        eg(T, L, NewState, RecordedStates, X).


    % EF
    check(T, L, S, U, ef(X)) :-     
        % Find the available next states
        member([S, AvailableStates], T),

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),

        % Generate an available state
        not_member(AvailableStates, U, NewState),

        % Check X in the new state
        check(T, L, NewState, RecordedStates, ef(X));

        % WHAT THE FUCK
        member([S, AvailableStates2], T),
        appendEl(S, U, RecordedStates2),
        not_member(AvailableStates2, U, NewState2),

        check(T, L, NewState2, RecordedStates2, X).

    % AF
    check(T, L, S, U, af(X)) :- 
        check(T, L, S, U, X);

        % Add the current state to RecordedStates
        appendEl(S, U, RecordedStates),
        member([S, AvailableStates], T),

        foreach(
            not_member(AvailableStates, U, NewState),
            check(T, L, NewState, RecordedStates, af(X))
        ).


    % Literals
    check(_, L, S, U, X) :- member([S, R], L), member(X, R).