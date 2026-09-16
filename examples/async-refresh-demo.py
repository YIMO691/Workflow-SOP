"""Teaching example only: manually controlled awaits, no network, UI or files.

Run from the repository root with Python 3.10+: python -B examples/async-refresh-demo.py
The unsafe implementation intentionally contains defects. Exit 0 means the
specified checks exposed them and the guarded implementation passed those checks.
This is not a model evaluation or a production implementation.
"""

import json
from dataclasses import dataclass, field


@dataclass
class View:
    alive: bool = True
    busy: bool = False
    active: object = None
    writes: list = field(default_factory=list)

    def close(self):
        # This toy lifecycle invalidates the request and discards busy state.
        self.alive, self.busy, self.active = False, False, None


class Pending:
    def __await__(self):
        # The driver chooses which request returns or fails next.
        result = yield self
        return result


async def unsafe_refresh(view, setup):
    view.active = object()
    view.busy = True
    request = setup()  # Deliberate defect: initialization is outside cleanup.
    try:
        result = await request
        view.writes.append(result)  # No lifetime or request ownership check.
    finally:
        view.busy, view.active = False, None  # May clear a newer request.


async def guarded_refresh(view, setup):
    token = object()
    view.active, view.busy = token, True
    try:
        request = setup()
        result = await request
        if view.alive and view.active is token:
            view.writes.append(result)
    finally:
        if view.alive and view.active is token:
            view.busy, view.active = False, None


def advance(job, value=None, error=None):
    try:
        yielded = job.throw(error) if error is not None else job.send(value)
    except StopIteration:
        return
    if not isinstance(yielded, Pending):
        raise RuntimeError("Unexpected suspension in the teaching driver")


def check(condition, explanation):
    if not condition:
        raise AssertionError(explanation)


def check_case(implementation, case):
    view = View()
    jobs = []

    def start(setup=Pending):
        job = implementation(view, setup)
        jobs.append(job)
        advance(job)
        return job

    def expect_error(action):
        try:
            action()
        except RuntimeError as error:
            check(str(error) == "injected failure", "unexpected error")
        else:
            raise AssertionError("failure must remain observable to caller")

    try:
        if case == "initialization_failure":
            def fail_setup():
                raise RuntimeError("injected failure")

            expect_error(lambda: start(fail_setup))
            check(not view.busy, "initialization failure left the view busy")
            advance(start(), "retry")
            check(view.writes == ["retry"], "retry did not show its result")
            return

        first = start()
        if case == "normal":
            advance(first, "result")
            check(view.writes == ["result"] and not view.busy,
                  "normal response must display and clear busy")
        elif case == "closed_view":
            view.close()
            advance(first, "late")
            check(view.writes == [], "response wrote to a closed view")
        else:
            second = start()
            if case == "newer_response_wins":
                advance(second, "new")
                advance(first, "old")
                check(view.writes == ["new"], "old response overwrote new intent")
            elif case in ("old_success_cleanup", "old_failure_cleanup"):
                if case == "old_success_cleanup":
                    advance(first, "old")
                else:
                    expect_error(lambda: advance(first, error=RuntimeError("injected failure")))
                check(view.busy, "old cleanup cleared busy while newer request was pending")
                advance(second, "new")
                check(view.writes == ["new"] and not view.busy,
                      "new request must still display and complete")
            else:
                raise ValueError(case)
    finally:
        for job in jobs:
            job.close()


def main():
    cases = ("normal", "newer_response_wins", "closed_view",
             "initialization_failure", "old_success_cleanup", "old_failure_cleanup")
    rows = []
    for implementation in (unsafe_refresh, guarded_refresh):
        for case in cases:
            try:
                check_case(implementation, case)
                passed, detail = True, "behavior matched the scenario"
            except AssertionError as error:
                passed, detail = False, str(error)
            expected_pass = implementation is guarded_refresh or case == "normal"
            rows.append({"implementation": implementation.__name__, "case": case,
                         "passed": passed, "detail": detail,
                         "expected_outcome_observed": passed == expected_pass})
    print(json.dumps(rows, ensure_ascii=False, indent=2))
    return 0 if all(row["expected_outcome_observed"] for row in rows) else 1


if __name__ == "__main__":
    raise SystemExit(main())
