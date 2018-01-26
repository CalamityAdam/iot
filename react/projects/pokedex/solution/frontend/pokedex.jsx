import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { HashRouter, Route } from 'react-router-dom';

import configureStore from './store/store';
import PokemonIndexContainer from './components/pokemon/pokemon_index_container';

const Root = ({ store }) => (
    <HashRouter store={store}>
      <Route path="/" component={PokemonIndex} store={store}/>
    </HashRouter>
);

document.addEventListener('DOMContentLoaded', () => {
  const store = configureStore();
  const root = document.getElementById('root');

  ReactDOM.render(<Root store={store} />, root);
});


// <Provider store={store}>
//   <HashRouter>
//     <Route path="/" component={PokemonIndexContainer} />
//   </HashRouter>
// </Provider>
//
