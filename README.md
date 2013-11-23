Erlchestrate
============

Erlang client for [Orchestrate.io](http://orchestrate.io) API.

## Run

```
$ make shell
> application:ensure_all_started(erlchestrate).
> erlchestrate_app:set_token(....).
> erlchestrate_keys:put(<<"test_collection">>, <<"test_key">>, <<"true">>).
```

## Test

```
$ export TOKEN=...
$ make ct
```
