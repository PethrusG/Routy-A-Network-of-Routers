-module(dijkstra).
-export([table/2, route/2]).
% -compile(export_all).

entry(Node, Sorted) ->
    case lists:keyfind(Node, 1, Sorted) of
	{_, Shortest, _} ->
	    Shortest;
	false ->
	    0
    end.

replace(Node, N, Gateway, Sorted) ->
     case lists:keyfind(Node, 1, Sorted) of
         {_, _, _} ->	
	 SortedDelete = lists:keydelete(Node, 1, Sorted),
	 NewList = [{Node, N, Gateway}|SortedDelete],
	 lists:keysort(2, NewList);
	 false ->
	    no_such_node
    end.

update(Node, N, Gateway, Sorted) ->
    OldLen = entry(Node, Sorted),
    if N < OldLen ->
	replace(Node, N, Gateway, Sorted);
    true ->
	Sorted
    end.

% iterate(Sorted, Map, Table)
iterate([], _, Table) ->
    lists:reverse(Table);
iterate([{_, inf, _}|_], _, Table) ->
    lists:reverse(Table);
iterate([{Dest, Hops, Gate}|RestofSorted], Map, Table) ->
    Links = map:reachable(Gate, Map),
    NewSorted = updateSorted(Links, RestofSorted, Hops, Gate),
%    NewTable = [{Dest, Gate}|Table],
%    iterate(NewSorted, Map, NewTable).
    iterate(NewSorted, Map, [{Dest, Gate}|Table]).

updateSorted([], NewSorted, _, _) ->
    NewSorted;
updateSorted([Node|RestofLinks], Sorted, Hops, Gate) ->
    NewSorted = update(Node, Hops+1, Gate, Sorted),
    updateSorted(RestofLinks, NewSorted, Hops, Gate).

table(Gateways = [{_, _, _}|_], Map) ->
    NodeList = map:all_nodes(Map),
    TupleList = tupleListToList(Gateways),
    NewSorted = dummySorted(NodeList, TupleList),
    iterate(NewSorted, Map, []);
table(Gateways, Map) ->
    NodeList = map:all_nodes(Map),
    NewSorted = dummySorted(NodeList, Gateways),
    iterate(NewSorted, Map, []).
  
tupleListToList(TupleList) ->
    tupleListToList(TupleList, []).

tupleListToList([], List) ->
    lists:reverse(List);
tupleListToList([{Name, _, _}|Rest], List) ->
    tupleListToList(Rest, [Name|List]).


dummySorted(NodeList, Gateways) ->  
    dummySorted(NodeList, Gateways, []).

dummySorted([], _,  Sorted) ->
     lists:keysort(2, Sorted);
dummySorted([Node|RestOfNodes], Gateways, Sorted) ->
        case lists:member(Node, Gateways) of
            true ->
                dummySorted(RestOfNodes, Gateways, [{Node, 0, Node}|Sorted]);
            _ ->
	        dummySorted(RestOfNodes, Gateways, [{Node, inf, unknown}|Sorted])
        end.

route(Node, Table) ->
    case  lists:keyfind(Node, 1, Table) of
	{Node, Dest} ->
	    Dest;
	_  ->
	    not_found
    end.



    
    

    
