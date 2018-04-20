# Max Windowed Range

Given an array, and a window size `w`, find the maximum range
(`max - min`) within a set of `w` elements.

Let's say we are given the array [1, 2, 3, 5] and a window size of 3.
Here, there are only two cases to consider:

```
1. [1 2 3] 5
2. 1 [2 3 5]
```

In the first case, the difference between the max and min elements of
the window is two (`3 - 1 == 2`). In the second case, that difference is
three (`5 - 2 == 3`). We want to write a function that will return the
larger of these two differences.

## Learning Goals

* Get practice approaching a difficult problem using algorithms
* Be able to explain the time complexity of your solution
* Know the differences between a stack and a queue
* Be able to use simple data structures to build more complicated ones

## Phase 1: Naive Solution

One approach to solving this problem would be:

1. Initialize a local variable `current_max_range` to `nil`.
2. Iterate over the array and consider each window of size `w`. For each
   window:
  1. Find the `min` value in the window.
  2. Find the `max` value in the window.
  3. Calculate `max - min` and compare it to `current_max_range`. Reset
  the value of `current_max_range` if necessary.
3. Return `current_max_range`.

Implement this approach in a method, `max_windowed_range(array,
window_size)`. Make sure your code passes the following test cases:

```ruby
windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8
```

Think about the time complexity of your method. How many iterations are
required at each step? What is its overall time complexity in Big-O
notation?

## Phase 2: Optimized Solution

It turns out that it is quite costly to calculate the `min` and `max`
elements of each window. If we use the `min` AND `max` methods built
into Ruby, this costs us `2 * window_size` iterations for each window.
What if it were possible to calculate `min` and `max` instantaneously
(in constant time) per window? We can write a data structure to help
with this.

In the naive solution, we consider each window as a slice of the input
array. On the first iteration, we slice the array from index `0` to
index `w`. On the second iteration, we slice from `1` to `w + 1`, and so
forth. However, slicing an array is rather costly. Remember, a new array
is created when slicing an existing array.

### Overall Plan:

Since the window only moves one index at a time, it would be nicer to
represent it as a `queue`. Every time we move the window, we could
enqueue the next element and dequeue the last element. However, that
still leaves us with the problem of expensive `min` and `max` operations.

We will be building multiple data structures that will finally lead to
`MinMaxStackQueue` that will keep track of the `min` and `max` in constant 
time. We will be building the following in order:

  + `MyQueue`
  + `MyStack`
  + `StackQueue`
  + `MinMaxStack`
  +  `MinMaxStackQueue`

### Phase 2: Queues

A **queue** is an simple abstract linear data structure where elements are stored in order
and can be added or removed one at a time. A queue follows **first in,
first out** (FIFO). Unlike Ruby's Array data structure, most Queue
implementations do not expose methods to slice or sort the data, or to
find a specific element. The basic operations are:

- Queue
  - `enqueue`: adds an element to the back of the queue
  - `dequeue`: removes an element from the front of the queue and
    returns it

We will also write a `peek` method, which returns the "top" or "next"
item without actually removing it. We will be using method to "check" __________________

Queues may be implemented in terms of simpler data structures, such as
linked lists, but in Ruby you can actually use an Array as the underlying
data store, as long as you don't expose it publicly (i.e., don't define an
`attr_reader` for it). We'll do this in today's exercises.

Implement a Queue class. Use the following `initialize` method as a
starting point:

```ruby
class MyQueue
  def initialize
    @store = []
  end
end
```

Implement `enqueue`, `dequeue`, `peek`, `size`, and `empty?` methods on your Queue.

### Phase 3: Stacks

Stacks are another simple linear data structure. Elements are
also stored in order and can be added or removed one at a time. A stack 
is **first in, last out** (FILO). Similar to queues, stack implementations
do not expose methods to slice or sort the data, or to find a specific element.
The basic operations are: 

- Stack
  - `push`: adds an element to the top of the stack
  - `pop`: removes an element from the top of the stack and returns it

Implement a Stack class. Use the following `initialize` method as a
starting point:

```ruby
class MyStack
  def initialize
    @store = []
  end
end
```

Implement `pop`, `push`, `peek`, `size`, and `empty?` methods on your Stack.



----------- the rest of under construction ----------------------



### Phase 4: MinMaxStackQueue

Next, we're going to implement a queue again, but with a twist: rather
than use an Array, we will implement it using our `MyStack` class under
the hood.

Before you start to code this, sit down and talk to your partner about
how you might implement this. You should not modify your `MyStack`
class, but use the interface it provides to implement a queue. When
you're ready, implement this `StackQueue` class with `enqueue`,
`dequeue`, `size`, and `empty?` methods.

**Hint**: You will want to use more than one instance of `MyStack`.

**Hint 2**: What if you always pushed onto one stack, and always popped
from the other? How will these two stacks interact?

**Hint 3**: Think about how a slinky walks down stairs...

Ask your TA if you get stuck!







### Writing the Optimized Solution

Armed with a working MinMaxStackQueue, this problem should be much
easier. You'll want to follow the same basic approach as above, but use
your new data structure instead of array slices. As before, return the
`current_max_range` at the end of the method. Make sure all the test
cases pass, and that you both understand the time complexity of this
solution. Then talk to your TA about it and have them review your code!
