-module(map).
-compile(export_all).

new() ->
    [].

update(Node, Links, _Map) ->
    [{Node, Links}].

reachable(_, []) ->
    [];
reachable(Node, [{Node, Links}|_]) ->
    Links;
reachable(Node, [_|T]) ->
    reachable(Node, T).

all_nodes(Map) -> all_nodes(Map, []).

all_nodes([], []) ->
    [];
all_nodes([], NodeList) ->
    lists:usort(NodeList);
all_nodes([{Node, List}|MapRemain], NodeList) ->
    NewNodeList = NodeList ++ [Node] ++ List,
    all_nodes(MapRemain, NewNodeList).


% all_nodes([Map = {Node, _}|T]) ->
%    lists:map(fun() -> Node end, Map).
    
		     
%% all_nodes(Map) ->
%%     lists:foldl(fun({node, _} -> node end), Map).

			   
