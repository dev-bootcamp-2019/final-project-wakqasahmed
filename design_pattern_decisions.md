# Design Patterns Decisions

1. `Fail early and fail loud` pattern is applied by using `require` validation instead of silent if statements to avoid unnecessary code execution.

2. `Circuit Breaker` pattern is applied to stop certain operations of marketplace when needed (e.g. add new item, buy an item and claim funds).