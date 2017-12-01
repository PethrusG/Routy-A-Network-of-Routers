-module(intf).
-compile(export_all).

new() ->
    [].

add(Name, Ref, Pid, Intf) ->
   lists:reverse([{Name, Ref, Pid}|Intf]).

remove(Name, Intf) ->
    lists:keydelete(Name, 1, Intf).

lookup(Name, Intf) ->
    case lists:keyfind(Name, 1, Intf) of
	{_, _, Pid}  ->
	    {ok, Pid};
	_ ->
	    notfound	
    end.

ref(Name, Intf) ->
    case lists:keyfind(Name, 1, Intf) of
	{_, Ref, _} ->
	    {ok, Ref};
	_ ->
	    notfound
    end.

name(Ref, Intf) ->
     case lists:keyfind(Ref, 2, Intf) of
	{Name, _,  _} ->
	    {ok, Name};
	_ ->
	    notfound
    end.

list(Intf) -> list(Intf, []).

list([], Names) ->
    lists:reverse(Names);
list([{Name, _, _}|T], Names) ->
    list(T, [Name|Names]).

broadcast(_, []) ->
    done;
broadcast(Message, [{_, _, Pid} | T]) ->
    Pid ! Message,
    broadcast(Message, T).
    
    
    

    
    
	    
