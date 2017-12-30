import merge from 'lodash/merge';

import {
  RECEIVE_BENCH,
  RECEIVE_REVIEW,
} from '../actions/bench_actions';

const reviewsReducer = (state = {}, action) => {
  Object.freeze(state);
  const newState = merge({}, state);

  switch (action.type) {
    case RECEIVE_BENCH:
      return merge(newState, action.reviews);
    case RECEIVE_REVIEW:
      const { review } = action;
      return merge(newState, { [review.id]: review });
    default:
      return state;
  }
}
