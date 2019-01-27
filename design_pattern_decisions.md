# Design Pattern Decisions

1. `Fail early and fail loud` pattern is applied by using `require` validation instead of silent if statements to avoid unnecessary code execution.

2. `Circuit Breaker` pattern is applied to stop certain operations of marketplace when needed (e.g. add new item, buy an item and claim funds).

3. `Restricting Access` pattern is used to restrict other contracts' access to the state by making state variables private (e.g. the variable used to toggle store state).