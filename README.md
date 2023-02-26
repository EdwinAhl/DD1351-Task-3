# DD1351-Task-3
Model checker for CTL

## Predicates supported
- X
- neg(X)
- and(X,Y)
- or(X,Y)
- AX(X)
- EX(X)
- AG(X)
- EG(X)
- AF(X)

## Example
![alt text](https://github.com/EdwinAhl/DD1351-Task-3/blob/master/model.jpg)

[[s1, [s2, s3]],
 [s2, [s3]],
 [s3, [s1, s6]],
 [s4, [s1, s3, s4]],
 [s5, [s2, s3]],
 [s6, [s7]],
 [s7, [s4]]].
> List of states containing nestled lists of their transitions.

[[s1, []],
  [s2, [start, error]],
  [s3, [close]],
  [s4, [close, heat]],
  [s5, [start, close, error]],
  [s6, [start, close]],
  [s7, [start, close, heat]]].
 > List of states containting nestled lists of variables true in respective state.

s1.
> Starting state.

and(ef(eg(close)), ef(eg(heat))).
> Expression to be evaluated to true or false (in this case true).
