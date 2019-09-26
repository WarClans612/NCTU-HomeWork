import numpy as np
import pandas as pd
import crossover
import mutation
import fitness

def mainloop(generation, pop, bandwidth_matrix, neighbor_matrix, k_shortest, population_size):
    # main loop
    fit_v_gen = []
    for g in range(generation):
        #display(pd.DataFrame(fitness.population_with_fitness(pop, bandwidth_matrix)))

        # crossover
        temp_pop = []
        for idx in range(len(pop)-1):
            child1, child2 = crossover.random_crossover(pop[idx], pop[idx+1], bandwidth_matrix)
            temp_child1 = crossover.check_cycle(child1)
            temp_child2 = crossover.check_cycle(child2)

            if len(temp_child1) != len(set(temp_child1)):
                print(child1, temp_child1)
                input()
            if len(temp_child2) != len(set(temp_child2)):
                print(child2, temp_child2)
                input()
            temp_pop += [temp_child1, temp_child2]

        # mutation
        children_pop = []
        for ind in pop:
            temp_child1 = mutation.mutation(neighbor_matrix, ind, 0.5)
            temp_child2 = crossover.check_cycle(temp_child1)
            if len(temp_child2) != len(set(temp_child2)):
                print(child2, temp_child2)
                input()
            children_pop.append(temp_child2)

        # diversity maintenance
        pop = np.unique(pop+temp_pop+children_pop).tolist()

        # fitness evaluation
        pop_with_fit = fitness.population_with_fitness(pop, bandwidth_matrix)

        # selection
        pop = pd.DataFrame(sorted(pop_with_fit, key=lambda ind: ind['fitness'], reverse=True))
        fit_v_gen.append(np.mean(pop['fitness'][:k_shortest]))
        #display(pop)
        pop = pop['individual'][0:population_size].tolist()
    return pop, fit_v_gen