The screen dimension is the window dimension.

The canvas is defined inside the screen.

The canvas dimension is scaled up by a factor of 128.

In OpenGL, we also need to define the visible region which 
is defined by glOrtho. The visible region is computed
based on the window dimension. We can only see the objects
inside the visible region.