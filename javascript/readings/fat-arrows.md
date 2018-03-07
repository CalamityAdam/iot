# Arrow Functions

Arrow functions, a.k.a. Fat Arrows, are a way of declaring functions. They were introduced in ES2015 as a way of solving many of the inconveniences of the normal callback function syntax.

## Anatomy of an Arrow Function
For multi-expression blocks:
```js
(parameters, go, here) => {
  statements;
  return value;
}
```

For single-expression blocks, `{ }` and `return` are implied, and you may omit the `( )` when there is a single argument.
```javascript
argument => expression; // equal to (argument) => { return expression };

(argument1, argument2) => expression //syntax for multiple arguments
```

__N.B.:__ In JavaScript, an _expression_ is a line of code that returns a value. _Statements_ are, more generally, any line of code.

Consider the following example:
```javascript
// normal callback function
function showEach(array) {
  array.forEach(function(el) {
    console.log(el);
  });
}

// fat arrow function
function showEach(array) {
  array.forEach(el => console.log(el));
}
```

Both functions in the above example will have the output but the fat arrow function achieved this with less lines of code. However, arrow functions aren't just syntactic sugar for normal functions, though. They behave differently in some scenarios:

## Scope

Arrow functions, unlike normal functions, do *not* create a new scope. In other words, `this` means the same thing inside an arrow function that it does outside of it. They are extremely useful if you want to keep the same scope throughout a function. Consider the following scenario with a normal function:

```javascript
//normal callback function
function Cat(name) {
  this.name = name;
  this.toys = ['string', 'ball', 'balloon'];
};

Cat.prototype.play = function meow() {
  //`this` in this scope is equal to the instance of Cat

  this.toys.forEach(function(toy) {
    //`this` in this scope is equal to the global scope
    console.log(`${this.name} plays with ${toy}`);
  });
};

let garfield = new Cat('garfield');
garfield.play();

// output
undefined plays with string
undefined plays with ball
undefined plays with balloon
```

`play` breaks because `this` in `this.name` refers to the scope of the `forEach` method. But if we rewrite `play` using a fat arrow function, it works:

```javascript
//fat arrow function

Cat.prototype.play = function meow() {
  //`this` in this scope is equal to the instance of Cat

  this.toys.forEach(toy => console.log(`${this.name} plays with ${toy}`));
  //`this` in this scope is *STILL* equal to the instance of Cat
};

garfield.play();

//output
garfield plays with string
garfield plays with ball
garfield plays with balloon
```

## Implicit Returns

Fat arrows implicitly return when they consist of a single expression.
```javascript
let halfMyAgeImplicit = myAge => myAge / 2;
halfMyAgeImplicit(30); // 15
```

This doesn't work if the fat arrow uses a block.
```javascript
let halfMyAgeExplicit = myAge => {
  let age = myAge;
  age / 2;
}

halfMyAgeExplicit(30); // "undefined"
```

To return a value from a fat arrow using a block, you must explicitly return.
```javascript
let halfMyAge = myAge => {
  let age = myAge;
  return age / 2;
}
halfMyAge(30); // 15
```

## Potential Pitfalls

### Syntactic Ambiguity

```javascript
let ambiguousFunction = () => {}
```

In Javascript, `{}` can signify either an empty object or an empty block.

Is `ambiguousFunction` supposed to return an empty object or an empty block? If so, it's broken because there's no way to distinguish between either alternative.

```javascript
typeof ambiguousFunction() === "undefined"; // true
```

Solution: To make a single-expression fat arrow return an empty object, wrap it in parentheses:

```javascript
clearFunction = () => ({});
typeof clearFunction() === "object"; // true
```

### No Binding

Fat arrows don't scope like normal functions, so you can't reassign `this`. `this` will always be what it was at the time the fat arrow was declared.
```javascript
let returnName = () => this.name;
returnName.call({name: 'Dale Cooper'}) // undefined;
```

### No Constructors

Fat arrows can't be used as constructors.

```javascript
const FatCat = (name) => this.name = name;

FatCat("Garfield") //"Garfield"
let g = new FatCat("garfield"); // TypeError: FatCat is not a constructor
```

### No `arguments`

Because fat arrow functions do not change scope, fat arrows don't have their own [`arguments`][arguments] object.

```javascript
const hasArgs = function() {
  // arguments is from the outer function.

  let noArgs = () => {
    console.log(arguments)
    //arguments is *still* from the outer function
    return arguments[0];
  }
  return noArgs('FakeArg');
};

hasArgs('RealArg') // returns 'RealArg';
```

[arguments]: ./arguments.md

### No Names

Fat arrows are _anonymous_, like their [`lambda`][lambda] counterparts in other languages.

```javascript
sayHello(name) => console.log(`Hi, ${name}!`); // SyntaxError
(name) => console.log(`Hi, ${name}!`); // correct
```

If you want to name your function you must assign it to a variable like this:
```js
const sayHello = (name) => console.log(`Hi, ${name}!`);
```

[lambda]: https://en.wikipedia.org/wiki/Anonymous_function
