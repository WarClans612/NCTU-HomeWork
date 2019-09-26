import random

def mutation(neighbor_matrix, parent, rate=0.1):
    # supposed individual is a list
    if len(parent) <= 2:
        pass
    else:
        ind = parent.copy()
        rate = min(0.9, rate)
        freq = max(1, int(rate * len(ind)))
        for i in range(freq):
            position = random.randint(1, len(ind)-2)
            prev_pos = ind[position-1]
            next_pos = ind[position+1]
            intersection = list(set(neighbor_matrix[prev_pos]) & set(neighbor_matrix[next_pos]))
            ind[position] = random.sample(intersection, 1)[0]

    return ind

def dirty_mutation(neighbor_matrix, ind):

    """ For increasing diversity,
        dirty_mutation will not guarantee
        whether new individual is subject to constraints"""

    # +1 is for matching the vertex number from 1 to N (not from 0)
    ind[position] = random.sample(len(neighbor_matrix), 1)[0]

    return ind

#mutation(neighbor_matrix, [1, 3, 4])
