# Full-stack Design Docs Preparation: Routes

Now that we know how to delegate some of our app state to our frontend router, we should begin thinking about what routes we need in our full-stack projects. Let's consider backend routes first, then frontend.

Take some time to research the site you are cloning. Review each of the views you will be rendering, keeping these things in mind:
- Backend
  - What API route should the displayed resource(s) make requests to?
  - What other CRUD is happening on the page? Do we need create/edit/delete routes?
- Frontend
  - What component(s) is being displayed?
    - For example, at `/tweets`, we will render the `TweetsIndex`.
  - Does the component need a specific record? Can that record be identified by a wildcard in the URL?
  - If search results are being displayed, is the [query string][query-string] in the URL bar?

[query-string]: https://en.wikipedia.org/wiki/Query_string

Create a rough-draft of your backend and frontend routes. Our backend routes should generally remain RESTful, though there may be views that require multiple resources and therefore a custom route. For the frontend, try to model your app's routes to the one you are cloning. Remember, our frontend routes are being used to dictate what components will be rendered, so make sure to consider your route params.

## Example

For another example, see the [backend][bluebird-backend] and [frontend][bluebird-frontend] routes from _Bluebird_, a Twitter clone.

[bluebird-backend]: https://github.com/appacademy/bluebird/wiki/backend-routes
[bluebird-frontend]: https://github.com/appacademy/bluebird/wiki/frontend-routes