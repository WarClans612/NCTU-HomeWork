#include<iostream>
using namespace std;

class node{
public:
	node();
	node(int value);
	~node();
	friend void gothrough(node *p);

private:
	node *left, *right; // the left child and the right child pointer
	int number; // record the node's number
	int is_threadl, is_threadr; //the flag to record whether the pointer is a thread or not

	friend class op_tree_totum;//you could access all valuables in class op_tree_totum
};

//ctor
node::node(){
	left = right = NULL;
	is_threadl = 1;
	is_threadr = 1;
}

//ctor
node::node(int value){
	number = value;
	left = right = NULL;
	is_threadl = 1;
	is_threadr = 1;
}

//dtor
node::~node(){

}

class op_tree_totum{

public:
	op_tree_totum();
	~op_tree_totum();
	void insertion(int s);
	void deletion(int s);
	void inorder_run();
	void reverseorder_run();
	int size();

private:
	node *root, *head, *tail;
	int num;//caculate how many nodes in the totum
};

//ctor
op_tree_totum::op_tree_totum(){
	head = new node();
	tail = new node();
	head->right = tail; //initialize the head node to connect to the tail node
	tail->left = head;
	root = NULL;
	num = 0;
}

//dtor
op_tree_totum::~op_tree_totum(){
	node *p = root;
	if(p!=NULL)	gothrough(p);
	num = 0;
	if (head != NULL)delete head;
	if (tail != NULL)delete tail;
}

void gothrough(node *p){
	if (p->is_threadl==0 && p->left!= NULL) gothrough(p->left);
	if (p->is_threadr==0 && p->right!= NULL) gothrough(p->right);
	delete p;
}

void op_tree_totum::insertion(int s){
	//TODO: fill in the code to do the insertion of the node with number s
    node *target = root;
    //Searching for the node that will be the parent for this number node
    while(target != NULL)
    {
        //If the number to be inserted is larger
        if (s > target->number)
        {
            if(target->is_threadr) break;
            target = target->right;
        }
        //If the number to be inserted is smaller
        else if(s < target->number)
        {
            if(target->is_threadl) break;
            target = target->left;
        }
        //If the number has already been there
        else return;
    }
    //The number s is appropriate to be inserted
    ++num;

    //Creating new node to save the new number
    node *temp = new node(s);
    temp->left = head;
    temp->right = tail;

    //Reassign head or tail if the inserted is smaller or larger
    //If the tree is empty
    if(root == NULL)
    {
        root = temp;
        head->right = temp;
        tail->left = temp;
        return;
    }
    else if(temp->number < head->right->number) head->right = temp;
    else if(temp->number > tail->left->number) tail->left = temp;

    //Inserting the new node into the tree
    //If the number is larger than target's number
    if(s > target->number)
    {
        temp->right = target->right;
        temp->left = target;
        target->right = temp;
        target->is_threadr = 0;
    }
    //If the number is smaller than target's number
    else
    {
        temp->right =  target;
        temp->left = target->left;
        target->left = temp;
        target->is_threadl = 0;
    }
}

void op_tree_totum::deletion(int s){
	//TODO: fill in the code to do the deletion of the node with number s
	//Nothing to be deleted
	if(root == NULL) return;

	//Searching for the node to be deleted
	//Dest is node to be deleted
	//p is node exactly before dest
    node *dest = root, *p = root;
    while(1) {
        //If the number to be deleted is larger
        if (dest->number < s) {
            if (dest->is_threadr) return; //Number not found
            p = dest;
            dest = dest->right;
        //If the number to be deleted is smaller
        } else if (dest->number > s) {
            if (dest->is_threadl) return; //Number not found
            p = dest;
            dest = dest->left;
        } else {
            break; //We get the number to be deleted
        }
    }

    //While dest is not leaf node
    while(!dest->is_threadl || !dest->is_threadr)
    {
        //Get largest number from left node
        if(!dest->is_threadl)
        {
            p = dest;
            node *largest = dest->left;
            while (!largest->is_threadr) {
                p = largest;
                largest = largest->right;
            }
            dest->number = largest->number;
            dest = largest;
        }
        //Get smallest number from right node
        else if(!dest->is_threadr)
        {
            p = dest;
            node *smallest = dest->right;
            while (!smallest->is_threadl) {
                p = smallest;
                smallest = smallest->left;
            }
            dest->number = smallest->number;
            dest = smallest;
        }
    }
    //If it is not the only node in the tree
    if(p != dest)
    //If dest is the left child of its parent
    if(p->left == dest)
    {
        p->left = dest->left;
        p->is_threadl = 1;
    }
    //If dest is right child of its parent
    else if(p->right == dest)
    {
        p->right = dest->right;
        p->is_threadr = 1;
    }
    //Deletion of the desired node
    delete dest;
    //Number of node in the tree decrease
    --num;

    //If the tree after deletion is empty
    if(num == 0)
    {
        root = NULL;
        head->right = tail;
        tail->left = head;
    }
    else
    {
        //Reset its head and tail node to appropriate node
        node *smallest = root;
        while (!smallest->is_threadl) {
            smallest = smallest->left;
        }
        head->right = smallest;

        node *largest = root;
        while (!largest->is_threadr) {
            largest = largest->right;
        }
        tail->left = largest;
    }

}

void op_tree_totum::inorder_run(){
	//TODO: travel the tree from the head node to the tail node and output the values
	//You should NOT use stack or recurtion
    node *temp = head;
    node *pointer;
    //Nothing to be printed
    if(root == NULL) return;
    //Traverse from head to tail pointer
    else while(temp != tail->left)
    {
        pointer = temp;
        temp = temp->right;
        if(!pointer->is_threadr) while(!temp->is_threadl) temp = temp->left;
        cout << temp->number << " ";
    }
}

void op_tree_totum::reverseorder_run(){
	//TODO: travel the tree from the tail node to the head node and output the values
	//You should NOT use stack or recurtion
    node *temp = tail;
    node *pointer;
    //Nothing to be printed
    if(root == NULL) return;
    //Traverse from tail to head pointer
    else while(temp != head->right)
    {
        pointer = temp;
        temp = temp->left;
        if(!pointer->is_threadl) while(!temp->is_threadr) temp = temp->right;
        cout << temp->number << " ";
    }
}

int op_tree_totum::size(){
	return num;
}
