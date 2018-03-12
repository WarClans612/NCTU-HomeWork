
static const char* student_id = "0416106" ;


// do not edit prototype
void Insert(int *, int);
void Delete(int *, int);
int Select(int *, int);
int Rank(int *, int);

// data structure :
// tree is an array with enough space
// tree[0] is the array size
// bundle three attribute as a node data
// First attribute is color, "0" means black, "1" means red , NIL is also "0", "-1" means no data
// Second attribute is key, "0" means NIL, "1"~"999" means data,  "-1" means no data
// Third attribute is size, for Dynamic Order Statistics, "0" means NIL , "-1" means no data
//
// for example,
// if tree[0] is "256" says that the array size is 256
//
// if tree[1] is "1" says that the place of 1 is a red node
//
// if tree[2] is "5" says that the place of 1 is key of 5
//
// if tree[8] is "-1" says that the place of 3 has nothing
//
// if tree[14] is "0" says that the place of 5 is a node of NIL
//
// if tree[19] is "66" says that the place of 7 is key of 66

//
// if there is an ambiguous situation, choose the smaller ( left ) one
//

#define RED 1
#define BLACK 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
class node
{
public:
    node() {parent = nullptr; left = nullptr; right = nullptr; sizes = 1;}
    int key;
    int color;
    int sizes;
    node *parent;
    node *left;
    node *right;
};

class rb_tree
{
public:
    rb_tree();
    ~rb_tree();
    void build_tree(int *arrays, int index, int maximum);
    void build_tree_from_array(node **pointer, node *parents, int *arrays, int index, int maximum);
    void insert_key(node *newcomer);
    void rb_insert_fixup(node *newcomer);
    void return_tree_into_array(node *pointer, int *arrays, int index, int maximum);
    void return_tree(int *arrays, int index, int maximum);
    void rb_transplant(node *u, node *v);
    node* tree_maximum(node *pointer);
    void rb_delete_fixup(node *pointer);
    node* search_key(int keys);
    void size_maintain(node *current);
    void delete_key(node *sacrifice);
    node* OS_select (node *x, int i);
    int selection (int i);
    int OS_rank (node *x);
    void left_rotate(node *x);
    void right_rotate(node *y);
public:
    void destroy_tree(node *pointer);
    node *root;
    node *sentinel;
};

void rb_tree::destroy_tree(node *pointer)
{
    if (pointer->left != sentinel) destroy_tree(pointer->left);
    if (pointer->right != sentinel) destroy_tree(pointer->right);
    delete pointer;
}

rb_tree::rb_tree()
{
    sentinel = new node;
    sentinel->parent = sentinel;
    sentinel->left = sentinel;
    sentinel->right = sentinel;
    sentinel->key = 0;
    sentinel->color = BLACK;
    sentinel->sizes = 0;
    root = sentinel;
}

rb_tree::~rb_tree()
{
    destroy_tree(root);
    delete sentinel;
}

void rb_tree::left_rotate(node *x)
{
    node *y;
    y = x->right;
    x->right = y->left;
    if (y->left != sentinel) y->left->parent = x;
    y->parent = x->parent;
    if (x->parent == sentinel) root = y;
    else if (x == x->parent->left) x->parent->left = y;
    else x->parent->right = y;
    y->left = x;
    x->parent = y;
    y->sizes = x->sizes;
    x->sizes = x->left->sizes + x->right->sizes + 1;
    return;
}

void rb_tree::right_rotate(node *y)
{
    node *x;
    x = y->left;
    y->left = x->right;
    if (x->right != sentinel) x->right->parent = y;
    x->parent = y->parent;
    if (y->parent == sentinel) root = x;
    else if (y == y->parent->right) y->parent->right = x;
    else y->parent->left = x;
    x->right = y;
    y->parent = x;
    x->sizes = y->sizes;
    y->sizes = y->left->sizes + y->right->sizes + 1;
    return;
}

void rb_tree::rb_insert_fixup(node *newcomer)
{
    while (newcomer->parent->color == RED)
    {
        if (newcomer->parent == newcomer->parent->parent->left)
        {
            node *y = newcomer->parent->parent->right;
            if( y->color == RED)
            {
                newcomer->parent->color = BLACK;
                y->color = BLACK;
                newcomer->parent->parent->color = RED;
                newcomer = newcomer->parent->parent;
            }
            else
            {
                if (newcomer == newcomer->parent->right)
                {
                    newcomer = newcomer->parent;
                    left_rotate(newcomer);
                }
                newcomer->parent->color = BLACK;
                newcomer->parent->parent->color = RED;
                right_rotate(newcomer->parent->parent);
            }
        }
        else
        {
            node *y = newcomer->parent->parent->left;
            if( y->color == RED)
            {
                newcomer->parent->color = BLACK;
                y->color = BLACK;
                newcomer->parent->parent->color = RED;
                newcomer = newcomer->parent->parent;
            }
            else
            {
                if (newcomer == newcomer->parent->left)
                {
                    newcomer = newcomer->parent;
                    right_rotate(newcomer);
                }
                newcomer->parent->color = BLACK;
                newcomer->parent->parent->color = RED;
                left_rotate(newcomer->parent->parent);
            }
        }
    }
    root->color = BLACK;
    return;
}

void rb_tree::insert_key(node *newcomer)
{
    node *y = sentinel;
    node *x = root;
    while(x != sentinel)
    {
        ++x->sizes;
        y = x;
        if(newcomer->key < x->key) x = x->left;
        else x = x->right;
    }
    newcomer->parent = y;
    if(y == sentinel) root = newcomer;
    else if (newcomer->key < y->key) y->left = newcomer;
    else y->right = newcomer;
    newcomer->left = sentinel;
    newcomer->right = sentinel;
    newcomer->color = RED;
    rb_insert_fixup(newcomer);
    return;
}

void rb_tree::rb_transplant(node *u, node *v)
{
    if (u->parent == sentinel) root = v;
    else if (u == u->parent->left) u->parent->left = v;
    else u->parent->right = v;
    v->parent = u->parent;
    return;
}

node *rb_tree::tree_maximum(node *pointer)
{
    node *current = pointer;
    while(current->right != sentinel) current = current->right;
    return current;
}

void rb_tree::rb_delete_fixup(node *pointer)
{
    node *w;
    while (pointer != root && pointer->color == BLACK)
    {
        if (pointer == pointer->parent->left)
        {
            w = pointer->parent->right;
            if (w->color == RED)
            {
                w->color = BLACK;
                pointer->parent->color = RED;
                left_rotate(pointer->parent);
                w = pointer->parent->right;
            }
            if (w->left->color == BLACK && w->right->color == BLACK)
            {
                w->color = RED;
                pointer = pointer->parent;
            }
            else
            {
                if (w->right->color == BLACK)
                {
                    w->left->color = BLACK;
                    w->color = RED;
                    right_rotate(w);
                    w = pointer->parent->right;
                }
                w->color = pointer->parent->color;
                pointer->parent->color = BLACK;
                w->right->color = BLACK;
                left_rotate(pointer->parent);
                pointer = root;
            }
        }
        else
        {
            w = pointer->parent->left;
            if (w->color == RED)
            {
                w->color = BLACK;
                pointer->parent->color = RED;
                right_rotate(pointer->parent);
                w = pointer->parent->left;
            }
            if (w->right->color == BLACK && w->left->color == BLACK)
            {
                w->color = RED;
                pointer = pointer->parent;
            }
            else
            {
                if (w->left->color == BLACK)
                {
                    w->right->color = BLACK;
                    w->color = RED;
                    left_rotate(w);
                    w = pointer->parent->left;
                }
                w->color = pointer->parent->color;
                pointer->parent->color = BLACK;
                w->left->color = BLACK;
                right_rotate(pointer->parent);
                pointer = root;
            }
        }
    }
    pointer->color = BLACK;
    return;
}

void rb_tree::size_maintain(node *current)
{
    if(current == sentinel) return;
    size_maintain(current->left);
    size_maintain(current->right);
    current->sizes = current->left->sizes + current->right->sizes + 1;
    return;
}

void rb_tree::delete_key(node *sacrifice)
{
    if(sacrifice == sentinel) return;
    node *y = sacrifice;
    node *x = y->right;
    int y_original_color = y->color;
    if (sacrifice->left == sentinel)
    {
        x = sacrifice->right;
        rb_transplant(sacrifice, sacrifice->right);
    }
    else if (sacrifice->right == sentinel)
    {
        x = sacrifice->left;
        rb_transplant(sacrifice, sacrifice->left);
    }
    else
    {
        y = tree_maximum(sacrifice->left);
        y_original_color = y->color;
        x = y->left;
        if (y->parent == sacrifice) x->parent = y;
        else
        {
            rb_transplant(y, y->left);
            y->left = sacrifice->left;
            y->left->parent = y;
        }
        rb_transplant(sacrifice, y);
        y->right = sacrifice->right;
        y->right->parent = y;
        y->color = sacrifice->color;
    }
    if (y_original_color == BLACK) rb_delete_fixup(x);
    if (sacrifice->parent == sentinel) root->parent = sentinel;
    delete sacrifice;
    size_maintain(root);
    return;
}

node *rb_tree::search_key(int keys)
{
    node *current = root;
    while (current->key != keys)
    {
        if (current != sentinel)
        {
            if(keys < current->key) current = current->left;
            else current = current->right;
        }
        else return sentinel;
    }
    return current;
}

node *rb_tree::OS_select (node *x, int i)
{
    int r = x->left->sizes + 1;
    if (i == r) return x;
    else if (i < r) return OS_select(x->left, i);
    else return OS_select(x->right, i-r);
}

int rb_tree::selection (int i)
{
    node *answer = OS_select(root, i);
    return answer->key;
}

int rb_tree::OS_rank (node *x)
{
    if(x == sentinel) return 0;
    int r = x->left->sizes + 1;
    node *y = x;
    while (y != root)
    {
        if (y == y->parent->right) r = r + y->parent->left->sizes + 1;
        y = y->parent;
    }
    return r;
}
////////////////////////////////////////////////////////////////////////////////
void rb_tree::build_tree_from_array(node **pointer, node *parents, int *arrays, int index, int maximum)
{
    if(3*index < maximum && arrays[3*index-1] != 0 && arrays[3*index-1] != -1)
    {
        (*pointer) = new node;
        (*pointer)->key = arrays[3*index-1];
        (*pointer)->left = sentinel;
        (*pointer)->right = sentinel;
        (*pointer)->color = arrays[3*index-2];
        (*pointer)->sizes = arrays[3*index];
        (*pointer)->parent = parents;
        build_tree_from_array(&(*pointer)->left, (*pointer), arrays, 2*index, maximum);
        build_tree_from_array(&(*pointer)->right, (*pointer), arrays, 2*index+1, maximum);
    }
    return;
}

void rb_tree::build_tree(int *arrays, int index, int maximum)
{
    build_tree_from_array(&root, sentinel, arrays, index, maximum);
    return;
}

void rb_tree::return_tree_into_array(node *pointer, int *arrays, int index, int maximum)
{
    if(3*index < maximum)
    {
        if(pointer == sentinel)
        {
            if(pointer == root) return;
            arrays[3*index] = 0;
            arrays[3*index-1] = 0;
            arrays[3*index-2] = 0;
            return;
        }

        arrays[3*index] = pointer->sizes;
        arrays[3*index-1] = pointer->key;
        arrays[3*index-2] = pointer->color;
        return_tree_into_array(pointer->left, arrays, 2*index, maximum);
        return_tree_into_array(pointer->right, arrays, 2*index+1, maximum);
    }
    return;
}

void rb_tree::return_tree(int *arrays, int index, int maximum)
{
    return_tree_into_array(root, arrays, index, maximum);
    return;
}

void initialize_array_for_rb_tree(int *arrays, int maximum)
{
    for(int i = 1; i < maximum; ++i) *(arrays+i) = -1;
    return;
}
////////////////////////////////////////////////////////////////////////////////
void Insert(int * tree, int key) {
    rb_tree designated_tree;
    designated_tree.build_tree(tree, 1, *tree);
    node *news = new node;
    news->key = key;
    designated_tree.insert_key(news);
    initialize_array_for_rb_tree(tree, *tree);
    designated_tree.return_tree(tree, 1, *tree);
}

void Delete(int * tree, int key) {
    rb_tree designated_tree;
    designated_tree.build_tree(tree, 1, *tree);
    node *wanted_node;
    wanted_node = designated_tree.search_key(key);
    designated_tree.delete_key(wanted_node);
    initialize_array_for_rb_tree(tree, *tree);
    designated_tree.return_tree(tree, 1, *tree);
}

int Select(int * tree, int i) {
	// use Dynamic Order Statistics to return the i'th smallest element
    rb_tree designated_tree;
    designated_tree.build_tree(tree, 1, *tree);
	return designated_tree.selection(i);
}

int Rank(int * tree, int x) {
	// use Dynamic Order Statistics to return the rank of element x in the tree
    rb_tree designated_tree;
    designated_tree.build_tree(tree, 1, *tree);
    node *wanted_node;
    wanted_node = designated_tree.search_key(x);
	return designated_tree.OS_rank(wanted_node);
}
