import matplotlib.pyplot as plt
import pareto
from datetime import datetime

def plot_pareto(data, savefig=False):
    
    # get pareto_front
    front_idx = pareto.identify_pareto(data)
    pareto_front = data[front_idx]
    pareto_front.sort(axis=0)
    
    x = data[:,0]
    y = data[:,1]
    
    # construct figure
    fig = plt.figure(figsize=(6,4))

    # plot  data points
    plt.title("Pareto front ", fontsize=20)
    plt.scatter(x, y)
    plt.plot(pareto_front[:, 0], pareto_front[:, 1], color='r')

    # set plot metrics
    ylimit = [min(y)-1, max(y)+1]
    plt.ylim(ylimit)
    plt.xlabel('bottleneck bandwidth', fontsize=16)
    plt.ylabel('hop', fontsize=16).set_rotation(10)

    # Ref: https://stackoverflow.com/questions/9290938/how-to-set-my-xlabel-at-the-end-of-xaxis
    # Ref: https://stackoverflow.com/questions/37815976/setting-the-position-of-the-ylabel-in-a-matplotlib-graph
    ax = plt.gca()
    ax.yaxis.set_label_coords(-0.1,1.02)


    plt.show()
    
    if savefig == True:
        # savefig
        fig.savefig('./plots/pareto_'+datetime.now().strftime("%m%d_%H%M")+'.png') 
    return pareto_front
    
def plot_fitness_vs_generation(fit_v_gen, savefig=False):
    # construct figure
    fig = plt.figure(figsize=(6,4))

    # plot data points
    plt.plot(fit_v_gen)

    # set metrics
    plt.title("Average of top k fitness", fontsize=20)
    plt.xlabel('generation', fontsize=16)
    plt.ylabel('$\overline{fitness}$', fontsize=16, rotation=10)
    ax = plt.gca()
    ax.yaxis.set_label_coords(-0.07,1)

    plt.show()

    if savefig == True:
        # savefig
        fig.savefig('./plots/fitness_'+datetime.now().strftime("%m%d_%H%M")+'.png') 
