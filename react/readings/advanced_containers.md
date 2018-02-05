## Advanced Containers

While we said earlier that you should aim to have very few containers, there are exceptions.
What if we want a component to do two different things, depending on where we're using it, and it therefore needs different data from the store?
Separating our concerns with presentational and container components allows us to reuse presentational components where it makes sense, rather than duplicating code.
This means, though, that we'll need multiple containers for each reusable presentational component.

Consider a form component that may either create or edit a post.
The form itself looks and works the same in both cases; it has a few inputs and a submit button.
Our use cases differ, though, in that the edit form needs to map state from the store to its props, while the create form does not.
Furthermore, the edit form will need to dispatch a different action when the form submits than the create form will, as well as request the object from our backend.

Here's our presentational component, `PostForm`:

```js
// post_form.jsx
import React from 'react';

class PostForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = this.props.post; // a Post object has a title and a body
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  update(field) {
    return e => {
      this.setState({ [field]: e.target.value });
    };
  }

  handleSubmit(e) {
    e.preventDefault();
    // `submit` will be a thunk action that presumably creates or edits a post
    this.props.submit(this.state);
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>Title
          <input type="text" onChange={this.update('title')} value={this.state.title} />
        </label>

        <label>Body
          <input type="text" onChange={this.update('body')} value={this.state.body} />
        </label>

        <button>Submit Post</button>
      </form>
    );
  }
}

export default PostForm;
```

We can see that PostForm is expecting two things in props: a post object, and a submit function. The container will have to define these, since right now, this form can't actually do anything. Let's give it the ability to create a post:
```js
// create_post_form_container.js
import PostForm from './post_form';
import { connect } from 'react-redux';
import { createPost } from '../actions/post_actions';

const mapStateToProps = state => {
  return {
    post: { title: '', body: '' } // a default blank object
  };
};

const mapDispatchToProps = dispatch => {
  return {
    submit: post => dispatch(createPost(post))
  };
};

export default connect(mapStateToProps, mapDispatchToProps)(PostForm);
```

Simple enough, right?
Now, wherever we need a form to create a post, we can render `CreatePostFormContainer` by importing from the above file.
What about editing? This is a little trickier.

```js
// edit_post_form_container.jsx
// this is a .jsx file because we're going to use JSX in this container
import { connect } from 'react-redux';
import React from 'react';
import PostForm from './post_form';
import { fetchPost, updatePost } from '../actions/post_actions';

const mapStateToProps = (state, ownProps) => {
  const post = state.events[ownProps.match.params.postId];
  // get the post this route is asking for
  // (I'm assuming here that this component is being rendered by a route)
  return { post };
};

const mapDispatchToProps = dispatch => {
  // an edit form will need to fetch the post, but my PostForm shouldn't worry about that
  // we'll see how to handle this problem with a higher-order component
  return {
    fetchPost: id => dispatch(fetchPost(id)),
    submit: post => dispatch(updatePost(post)),
  };
};

class EditPostFormContainer extends React.Component {
  // Redux will give me a traditional container component when I call `connect`
  // this is just a higher-order component made to handle the fetch

  componentDidMount() {
    // do my fetching here so that PostForm doesn't have to
    this.props.fetchPost(this.props.match.params.postId);
  }

  render() {
    // destructure the props so I can easily pass them down to PostForm
    const { post, submit } = this.props;
    return (
      <PostForm post={post} submit={submit} />
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(EditPostFormContainer);
```

You can see here that we have one presentational component that is being reused, and two different containers.
This allows our presentational component to just concern itself with what the form will look like, while each container maps the necessary data and functionality for their respective use cases.
