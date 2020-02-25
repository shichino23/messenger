-module(dns).
-export([new/1, add_address/4, resolve_address/3, delete_address/3]).
-record(state, {table_id}).

new(_Opts) ->
    TableId = ets:new(?MODULE, [set, {write_concurrency, false},
                                {read_concurrency, false}]),
    State = #state{table_id=TableId},
    {ok, State}.

add_address(State=#state{table_id=TableId}, Bucket, Domain, Address) ->
    K = {Bucket, Domain},
    true = ets:insert(TableId, {K, Address}),
    {ok, State}.

resolve_address(State=#state{table_id=TableId}, Bucket, Domain) ->
    K = {Bucket, Domain},
    Res = case ets:lookup(TableId, K) of
              [] -> {not_found, K};
              [{_, Address}] -> {found, {K, Address}}
          end,
    {Res, State}.

delete_address(State=#state{table_id=TableId}, Bucket, Domain) ->
    K = {Bucket, Domain},
    true = ets:delete(TableId, K),
    {ok, State}.