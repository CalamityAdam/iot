import { RECEIVE_TODOS,
             RECEIVE_TODO } from '../actions/todo_actions';
import merge from 'lodash/merge';
    
const tagsReducer = (state = {}, action) => {
    Object.freeze(state);
    let nextState;

    switch (action.type) {
    case RECEIVE_TODOS:
        return action.payload.tags
    case RECEIVE_TODO:
        // console.log(action.payload.tags)
    // action.payload.tags.forEach(tag => nextState[tag.id] = tag);
    // return merge({}, state, nextState);
    default:
        return state;
    }
};
    
export default tagsReducer;