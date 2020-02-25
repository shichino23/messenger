-module(sender).
-export([send/2]).

send({Bucket, Domain}, Message) ->
    {_, {_, Res}} = messenger:resolve_address(Bucket, Domain),
    case Res of
        {found, {_, Address}} -> 
            %% プロセス間通信(ノード間通信をしたい場合はrpc callとか)
            Address ! Message,

            {ok, ok};
        {not_found, _} ->
            {error, dest_not_found}
    end.