#include <stdint.h>
#include <stdio.h>

#include "mp5.h"
#include "mp9.h"


int32_t
match_requests (graph_t* g, pyr_tree_t* p, heap_t* h,request_t* r1, request_t* r2,
		vertex_set_t* src_vs, vertex_set_t* dst_vs, path_t* path)
{
    src_vs->count = dst_vs->count = path->n_vertices = path->tot_dist = 0;     //initial 0     
    //find src vertex set
	find_nodes(&r1->from, src_vs, p, 0);
    trim_nodes(g, src_vs, &r2->from);   
	   
	//find dst vertex set
    find_nodes(&r1->to, dst_vs, p, 0);
    trim_nodes(g, dst_vs, &r2->to);  
    return (src_vs->count && dst_vs->count && dijkstra(g, h, src_vs, dst_vs, path));
}
