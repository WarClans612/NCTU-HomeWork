#!/usr/bin/env python
# coding: utf-8

import random

def crossover(chosen1, chosen2, cut_point1, cut_point2):
    '''
    This function will return 2 individual after crossover

        chosen1 (int): individual that is chosen as parent 1
        chosen2 (int): individual that is chosen as parent 2
        cut_point1 (int): location for the cut for individual 1
        cut_point2 (int): location for the cut for individual 2

        cut_point will represent the integer of the right of cutting location
        ex: 2
             |
        [0, 1, 2, 3]
    '''
    result1 = chosen1[:cut_point1] + chosen2[cut_point2:]
    result2 = chosen2[:cut_point2] + chosen1[cut_point1:]

    return result1, result2

def random_crossover(individual1, individual2, connection_matrix, ratio=0.9):
    '''
    This function return population after crossover is done

        chosen1 (int): individual that is chosen as parent 1
        chosen2 (int): individual that is chosen as parent 2
        connection_matrix (2d list): The connection matrix that represents the network (square matrix)
        ratio (float): probability of crossover occuring
    '''

    #Calculate all possible cut point
    max_possible = (len(individual1)-1) * (len(individual2)-1)

    if random.random() < ratio:
        #Check if cutting location is valid
        for i in range(100):
            cut_loc = random.randrange(0, max_possible)
            cut_point1 = cut_loc // (len(individual2)-1) + 1
            cut_point2 = cut_loc % (len(individual2)-1) + 1
            #print(max_possible, cut_loc, cut_point1, cut_point2)

            if(connection_matrix[individual1[cut_point1-1]][individual2[cut_point2]] == 0):
                continue
            if(connection_matrix[individual1[cut_point1]][individual2[cut_point2-1]] == 0):
                continue
            individual1, individual2 = crossover(individual1, individual2, cut_point1, cut_point2)
            break

    return individual1, individual2

def check_cycle(path):
    '''Check path contains cycle or not
    
    Assume source and destination is not the same
    
    Arguments:
        path (list): A list contains all the verticies sequences
    Return:
        cycle (list):
            - A list contains the path without all the loops
            - Returns the same path if the path does not contain any loop
    '''
    
    # If there's a vertex appear more then one time, there's bound to be a loop
    if(len(path) == len(set(path))):
        return path
    
    # Get rid of cycle
    vertex_dict = {}
    path_ = path
    idx_start = 0
    while(True):
        for idx, vertex in enumerate(path_[idx_start:]):
            idx_ = idx + idx_start
            if vertex not in vertex_dict:
                vertex_dict[vertex] = idx_
                if(idx_ == len(path_) - 1):
                    return path_
            # cycle detected
            else:
                cycle_start = vertex_dict[vertex] + 1
                
                if(idx_ == len(path_) - 1):
                    return path_[:cycle_start]
                
                # Remove vertices in cycle from dict
                for vertex_del in path_[cycle_start:idx_]:
                    del vertex_dict[vertex_del]
                path_ = path_[:cycle_start] + path_[idx_ + 1:]
                idx_start = cycle_start
                break

#fitness([0, 1, 4], crossover_matrix)
#print(population_with_fitness([[0,1], [0,1,4]], crossover_matrix))
#crossover([1, 4], [0, 1, 5, 2], 1, 2)
#print(random_crossover([[1, 4], [0, 1, 5, 2]], crossover_matrix))

