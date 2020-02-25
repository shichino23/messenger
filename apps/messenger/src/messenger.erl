-module(messenger).

-export([
         ping/0,
         send/2,
         add_address/3,
         resolve_address/2,
         delete_address/2
        ]).

-ignore_xref([
              ping/0,
              send/2,
              add_address/3,
              resolve_address/2,
              delete_address/2
             ]).

%% Public API
%% @doc Pings a random vnode to make sure communication is functional
ping() ->
    % argument to chash_key has to be a two item tuple, since it comes from riak
    % and the full key has a bucket, we use a contant in the bucket position
    % and a timestamp as key so we hit different vnodes on each call
    DocIdx = riak_core_util:chash_key({<<"ping">>, term_to_binary(os:timestamp())}),
    % ask for 1 vnode index to send this request to, change N to get more
    % vnodes, for example for replication
    N = 1,
    PrefList = riak_core_apl:get_primary_apl(DocIdx, N, messenger),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_spawn_command(IndexNode, ping, messenger_vnode_master).

send({Bucket, Domain}, Message) ->
    ReqId = make_ref(),
    send_to_one(ReqId, term_to_binary(os:timestamp()), {send, ReqId, {{Bucket, Domain}, Message}}).

add_address(Bucket, Domain, Address) ->
    ReqId = make_ref(),
    send_to_one(Bucket, Domain, {add_address, ReqId, {Bucket, Domain, Address}}).

resolve_address(Bucket, Domain) ->
    ReqId = make_ref(),
    send_to_one(Bucket, Domain, {resolve_address, ReqId, {Bucket, Domain}}).

delete_address(Bucket, Domain) ->
    ReqId = make_ref(),
    send_to_one(Bucket, Domain, {delete_address, ReqId, {Bucket, Domain}}).

%% Private functions
send_to_one(A, B, Cmd) ->
    DocIdx = riak_core_util:chash_key({A, B}),
    PrefList = riak_core_apl:get_primary_apl(DocIdx, 1, messenger),
    [{IndexNode, _Type}] = PrefList,
    riak_core_vnode_master:sync_spawn_command(IndexNode, Cmd, messenger_vnode_master).