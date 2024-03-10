#include <stdint.h>
#include <stdio.h>
#include "mp10.h"

void subtree(graph_t* g, pyr_tree_t* p, int32_t root, int32_t i) {
    if (4 * root + 1 >= p->n_nodes) {
        g->vertex[p->node[root].id].mm_bit = i;
    } else {
        for (int32_t i = 1; i <= 4; ++i) {
            if (4 * root + i < p->n_nodes) {
                subtree(g, p, 4 * root + i, i);
            }
        }
    }
}

int32_t mark_vertex_minimap (graph_t* g, pyr_tree_t* p)
{
    int32_t limit = (p->n_nodes <=64)?p->n_nodes : 64;
    for (int32_t i = 0; i < limit; ++i){
        subtree(g, p, i + 21, i);
    }
    return 1; 
}


void 
build_vertex_set_minimap (graph_t* g, vertex_set_t* vs)
{
    for (int32_t i = 0; i < vs->count; ++i) {
        vs->minimap |= (1ULL << g->vertex[vs->id[i]].mm_bit);
    }
}


void 
build_path_minimap (graph_t* g, path_t* p)
{
    for (int32_t i = 0; i < p->n_vertices; ++i) {
        p->minimap |= (1ULL << g->vertex[p->id[i]].mm_bit);
    }
}


int32_t
merge_vertex_sets (const vertex_set_t* v1, const vertex_set_t* v2,
		   vertex_set_t* vint)
{
    vint->count = 0;

    int32_t searchPtr = 0;
    for (int32_t i = 0; i < v1->count; ++i) {
        if (v1->id[i] == v2->id[searchPtr]) {
            vint->id[vint->count++] = v1->id[i];
            return 1;
        }else{
            while (searchPtr < v2->count - 1 && v1->id[i] > v2->id[searchPtr]) {
                ++searchPtr;
            }
        }       
    }
    return 0;
}