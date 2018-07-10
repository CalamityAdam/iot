# Deploying Your App to Heroku

Here is a quick guide to git yer app on the interwebs.

## Setup instructions

1. **Prepare your project for production**
  * Remove debuggers and console output
    * `cmd+shift+F` to search your project for debugger or console statements
  * Add the `rails_12factor` gem to production group of `Gemfile`
    * This allows us to view Heroku logs and will precompile our assets
    * **NB:** This gem has been integrated into Rails 5, so there is no need to include it if riding Rails 5
  * Add `engines` and `scripts` to `package.json`
    * Make sure to use the versions installed on your computer. Use `node -v` & `npm -v` in terminal

    ```json
    // package.json
    {
      "engines": {
        "node": "8.4.0",
        "npm": "6.1.0"
      },
      "scripts": {
        "postinstall": "webpack"
      }
    }
    ```
  * Execute `bundle install` and `npm install`. The `postinstall` script will
    take care of webpacking
    * Make sure everything installed correctly/nothing broke
  * Commit changes to master. Remember, we should only push working repos to Heroku.
    * Remember to include `node_modules` and `bundle.js*` in `.gitignore`

    ```sh
    git add Gemfile package.json other_files...
    git commit -m "Prepare for initial Heroku push"
    ```

2. **Create a new Heroku app**
  * Create an account on [heroku.com](http://www.heroku.com)
  * Create a new app
  * Setup buildpacks
    * `Settings` tab in Heroku Dashboard
    * Add `heroku/nodejs`, then `heroku/ruby`
      * **NB:** Buildpacks run in the order specified, which is why it is important to add `heroku/nodejs` first.
        If `heroku/ruby` ran first, it would recompile our assets *before* creating a new `bundle.js`. We want `bundle.js` to be up-to-date *before* Rails recompiles our assets.

3. **Install the Heroku CLI and make your initial push**
  * Install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line)
  * Login with `heroku login`
  * **NOTE:** if you are switching computers for development you will need to login on each switch, otherwise this should be a one-time action
  * Add `heroku` remote to project repo
  * Follow instructions in `Deploy` tab in Heroku Dashboard
    * You should already have a repo, so use `heroku git:remote -a appname` or `git remote add heroku https://git.heroku.com/appname.git`
  * Push to Heroku remote: `git push heroku master`
  * Check the status of your migrations with `heroku run rails db:migrate:status`
  * Setup production database with: `heroku run bundle exec rails db:migrate`
  * Optionally, include seed data with: `heroku run bundle exec rails db:seed`

4. ** Migrate static assets to the Asset Pipeline**
  * Put assets in `app/assets/`
  * Images should be in `app/assets/images/`
  * Use the Rails helpers (`image_url` for things in `app/assets/images/`, `asset_url` for anything in `app/assets/`) to generate the URL.
  * For use in Rails views:
    ```html
    <img src="<%= image_url('brent.png') %>" />
    ```
  * For use in React:
    ```html
    <!-- application.html.erb -->
    <script type="text/javascript">
      window.brentURL = "<%= image_url('brent.png') %>"
    </script>
    ```
    ```js
    // your component
    render() {
      render <img src={window.brentURL} />;
    }
    ```
  * For use in [SASS](https://www.sitepoint.com/an-introduction-to-sass-in-rails/)
    ```scss
    image-url('brent.png')
    asset-url('brent.png')
    ```

## Common Gotchas

* Heroku build failed
  * This probably means there was a syntax error in one of your precompiled assets. Check the build output and try to find the culprit
* Heroku build was successful, but nothing shows up on the page and there are no console errors
  * Failed to webpack your frontend. Double check your `postinstall` script, ensure there is only one `scripts` key in your `package.json` and make sure `webpack` is listed in your `package.json` `dependencies`
* "We're sorry, but something went wrong" error message appears on page load
  * Something is failing silently server-side. Use `heroku logs -t` to see your server logs and debug the issue
* Can't fetch any data
  * Make sure you created, migrated and seeded your database on Heroku
  * Run `heroku run rails db:migrate:status` to see which migrations you have and haven't run yet on Heroku
* Changing only capitalization when renaming a file.
  * Git will fail to recognize the change. Use `git mv -f <old_file_name> <new_file_name>` to force the update
* Asset pipeline not retrieving an asset, but is looking in the right directory (on `localhost`)
  * Assets are only precompiled when the server is starts up. Try restarting your server to initiate precompiling
* Missing package errors in console when viewing production site, but none on `localhost`
  * Likely using a global dependency in your project. This would be installed locally, but not on Heroku. Verify that *all* dependencies are included in your `package.json`

## Helpful Console Commands
* `heroku logs -t` - opens running server log of your Heroku app
* `heroku run <command>` - can run any terminal command
  * `heroku run bundle exec rails console`
  * `heroku run bundle exec rails db:<cmd>`
* `heroku pg:psql` - connect to Postgres db (in lieu of `rails dbconsole`)
* `heroku pg:reset DATABASE_URL` - used to drop and reset your Heroku Postgres database (we don't have permissions to run `rails db:reset` and `rails db:drop` on Heroku)
  * `DATABASE_URL` is a Heroku config variable we can reference from the command line
  * Make sure to run `heroku run rails db:migrate` and `heroku run rails db:seed` to remigrate and reseed your database
* `heroku open` - opens your app in the browser

## Setting up a Custom Domain

**NB:** This is not a requirement for the initial submission of your full-stack project, but will be required at the beginning of the Job Curriculum.

Check out our reading on [setting up a custom domain][domains] to find out more.

[domains]: ../expository_readings/domains.md
