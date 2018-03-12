#include<iostream>
#include<set>
#include<map>
#include<fstream>
#include<vector>
#include<algorithm>
using namespace std;

//Class for disjoint sets
class disjoint_set
{
    class Node {public: int parent; int ranks;};
    private:
        map<int, Node> maps;

    public:
    //Making individual disjoint sets
    void makeSet(int data)
    {
        Node node;
        node.parent = data;
        node.ranks = 0;
        maps[data] = node;
    }
    //Union
    void unions(int data1, int data2)
    {
        int parent1 = findset(data1);
        int parent2 = findset(data2);
        //cout << data1 << "-->" <<  parent1 << " " << data2 << "-->" << parent2 << endl;

        //Checking if they are the same sets
        if(parent1 == parent2) return;

        //The higher rank will be the parent
        if(maps[data1].ranks >= maps[data2].ranks)
        {
            //Increment rank if they are the same rank
            maps[data1].ranks = (maps[data1].ranks == maps[data1].ranks) ? ++maps[data1].ranks : maps[data1].ranks;
            maps[parent2].parent = parent1;
        }
        else maps[parent1].parent = parent2;
    }
    //Finding using collapsing finds
    int findset(int data)
    {
        int parent = maps[data].parent;
        if(data == parent) return parent;
        maps[data].parent = findset(maps[data].parent);
        return maps[data].parent;
    }
};

//Vertex class
class vertex
{
    public:
        vertex(){};
        int from, to, weight;
};
//Class for vertex sort
struct v_sort{ bool operator()(vertex a, vertex b) {return a.weight < b.weight;};};

int main()
{
    //Opening file
    fstream file;
    file.open("test.txt");

    //Declaring a disjoint set and set to maintain uniqueness
    int total = 0;
    set<int> myset;
    disjoint_set dis;

    //Reading vertex into the vector
    vector<vertex> graph;
    for(vertex v; file >> v.from;)
    {
        file >> v.to;
        myset.insert(v.from);
        myset.insert(v.to);
        file >> v.weight;
        graph.push_back(v);
    }
    sort(graph.begin(), graph.end(), v_sort());

    //Creating individual
    for(set<int>::iterator it = myset.begin(); it!= myset.end(); ++it) dis.makeSet(*it);

    //Kruskall's Algorithm
    for(int i = 0; i < graph.size(); ++i)
    {
        //Searching the parent of the from and to vertex
        int root1 = dis.findset(graph[i].from);
        int root2 = dis.findset(graph[i].to);

        //Determining if they are from the same disjoint set
        if(root1 == root2) continue;
        else
        {
            //Print answer
            cout << graph[i].from << " " << graph[i].to << " " << graph[i].weight << endl;
            //Add it to the total
            total += graph[i].weight;
            //Make it into the same disjoint set
            dis.unions(graph[i].from, graph[i].to);
        }
    }
    cout << total;

    return 0;
}
