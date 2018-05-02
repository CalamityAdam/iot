# Redux Developer Tools

Redux has its own special set of developer tools. They allow you to do things
like inspect your application state in real time as you use your app, or cancel
an action to see a live recalculation of the state as if that action had never
been dispatched. They require only a few minutes of setup, and can be well
worth the effort.

## Instructions

1) Install the [chrome extension][chrome_extension].

2) nstall the node package onto your project.

```Shell
npm install --save-dev redux-devtools-extension
```

3) Make the following changes to your `/frontend/store/store.js`.

```diff
  // frontend/store/store.js

  import { createStore, applyMiddleware } from 'redux';
  import thunk from 'redux-thunk';
  import logger from 'redux-logger';
+ import { composeWithDevTools } from 'redux-devtools-extension';

  import rootReducer from '../reducers/root_reducer';

  const configureStore = (preloadedState = {}) => (
    createStore(
      rootReducer,
      preloadedState,
+     composeWithDevTools(applyMiddleware(thunk, logger))
-     applyMiddleware(thunk, logger)
    )
  );

  export default configureStore;
```

Great job.

## Use

Now that we've set up the Redux dev tools, let's try them out.
We will use the [fruit stand app][fruit_stand] as an example.

1) To install a simple server, run `npm install -g http-server`.
2) Open the root directory of the fruit stand app and run `http-server`.
3) In your browser, navigate to `localhost:8080` to see the fruit stand app.
4) You should see an atom (a nucleus with electrons) icon on your Chrome toolbar,
and if you've set up the dev tools correctly it should now be green. Click on it.
5) When the dev tools open, click one of the buttons on the very bottom left to
open them in a new window.
6) Now try adding some fruit.
  + This will cause actions to be dispatched.
  + You should see those actions popping up in the dev tools.
  + You can click on them to cancel them and you should see the state recalculated in real time.

The dev tools have some other handy features, so click around and explore!

## Resources

* [Redux Dev Tools - Chrome Extension][chrome_extension]
* [Redux Dev Tools - Github Page][react_component]
* [Redux Dev Tools - Demo][redux_demo]

[fruit_stand]: https://github.com/appacademy/curriculum/tree/master/react/demos/fruit_stand_demos/fruit_stand_02
[chrome_extension]: https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd
[react_component]: https://github.com/gaearon/redux-devtools
[redux_demo]: http://extension.remotedev.io/#demo 