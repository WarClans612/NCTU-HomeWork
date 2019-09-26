def fitness(individual, connection_matrix):
    '''
    This function return an integer of the fitness value for individual

        individual (1d list): list of nodes in an individual
        connection_matrix (2d list): The connection matrix that represents the network (square matrix)
    '''
    return min(connection_matrix[individual[i]][individual[i+1]] for i in range(len(individual)-1))

def population_with_fitness(population, connection_matrix):
    '''
    This function will return population with each individuals fitness
    Format:
    [
        { 'individual': [], 'fitness': int }, ...
    ]

        population (2d list): population for the given network
        connection_matrix (2d list): The connection matrix that represents the network (square matrix)
    '''
    return list({'individual':individual, 'fitness':fitness(individual, connection_matrix)}
                for individual in population)
    