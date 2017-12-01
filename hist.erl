-module(hist).
-compile(export_all).

new(Name) ->
    [{Name, inf}].

update(Node, N, History) ->
    case lists:keyfind(Node, 1, History) of
	{_, Current} ->
	    if N =< Current ->
	        old;
	    true ->
		HistDelete = lists:keydelete(Node, 1, History),
	        {new,  [{Node, N+1}|HistDelete]}
	    end;
	 _ ->
	     {new,  [{Node, N+1}|History]}
     end.
    
