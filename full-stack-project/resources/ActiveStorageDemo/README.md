# Active Storage Attachment / React File Upload Demo
This demo shows how to upload images using React, Active Storage, and AWS S3.

## Demo


#### Videos
- [Part One (active storage, aws)](https://vimeo.com/278084990)
- [Part Two (uploading files via a react form)](https://vimeo.com/278085119)


## Key Files
- [post.rb](./app/models/post.rb)
- [api/posts/index.json.jbuilder](./app/views/api/posts/index.json.jbuilder)
- [Form.jsx](./frontend/form.jsx)
- [storage.yml](./config/storage.yml)
- [development.rb](./config/environments/development.rb#L31)
- [production.rb](./config/environments/production.rb#L42)
- [credentials.yml.enc](./config/credentials.yml.enc)

## Useful Docs
- [ActiveStorage README](https://github.com/rails/rails/blob/master/activestorage/README.md)
- [ActiveStorage Guide](http://guides.rubyonrails.org/active_storage_overview.html)
- [AWS](http://aws.amazon.com/)
- [FileReader](https://developer.mozilla.org/en-US/docs/Web/API/FileReader)
- [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData)

### Setting up AWS

- The first thing we need to set up is our buckets. This is where amazon will actually store our files. Click on 'S3' and then 'Create Bucket'. We should make a separate bucket for development and production. I would use something like `app-name-dev` and `app-name-pro`. Set the region to the one closest to you (that's N. Virginia if you're in New York).
- Now we have space set aside on AWS, but we don't have permission to access it. We need to create a user, and a policy for them to access your buckets. Go back to the main page and click 'Identity and Access Management' then click 'Users' on the left. We'll make a new user, named whatever you like.
- You'll be directed to a page with your brand new security credentials, DOWNLOAD AND SAVE THEM NOW, you will not have access to them again. If you do lose them, just delete the user and make a new one.
- The keys you just saved give you access to your AWS server space, **don't push them to GitHub, or put them anywhere public!**
- Now we need to set up the security policy for our new user. This is how they will be allowed to connect. Click 'Attach existing policies directly' and then 'Create Policy'. You can use this sensible default and not worry too much about what it's doing for you (borrrrriing). Remember to switch out bucket-name for your bucket.
### User Policy
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1420751757000",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::{BUCKET-NAME-DEV}",
        "arn:aws:s3:::{BUCKET-NAME-DEV}/*",
        "arn:aws:s3:::{BUCKET-NAME-PRO}",
        "arn:aws:s3:::{BUCKET-NAME-PRO}/*"
      ]
    }
  ]
}
```
- Don't forget we also need a policy for each of your buckets that allows the user you just created to access it. Use this template
### Bucket Pollicy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1420751757000",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::{YOUR-AWS-ACCOUNT-ID}:user/{YOUR-USER-NAME}"
            },
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::{YOUR-BUCKET-NAME}",
              "arn:aws:s3:::{YOUR-BUCKET-NAME}/*"
            ]
        }
    ]
}
```
- That's pretty much it for AWS. Now we have to convince Active Storage to use it!

### Setting up Active Storage

- First add `gem "aws-sdk-s3"` to your Gemfile and bundle install.

- Run `bundle exec rails active_storage:install` to create the migrations for the attachments and blobs tables. You don't have to worry about what columns are in these tables!

- Run `bundle exec rails db:migrate` to run the migrations.

- Add the attachment association to your desired model

```ruby
class Post < ApplicationRecord
  has_one_attached :photo
  # has_many_attached :photos
end
```

- Great, next we need to set up Active Storage to save to AWS.
- Run `bundle exec rails credentials:edit` (You should make sure you default editor is set to Atom if you're not comfortable with vim. Add this line `export EDITOR="atom -w"` to your ~/.bash_profile).
- Once the editor opens with your unencrypted credentials file, you should add your keys to look something like this.

```yml
aws:
  access_key_id: "XXXX"
  secret_access_key: "XXXX"
  region: "us-east-1"
  dev:
    bucket: "BUCKET-NAME-DEV"
  prod:
    bucket: "BUCKET-NAME-PROD"

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: XXXXXX

```

Double check your `s3_region` [here][aws-regions] (scroll down to **API Gateways**).

[aws-regions]: http://docs.aws.amazon.com/general/latest/gr/rande.html
- Next we have to add our services to our `storage.yml`.

```yml
amazon_dev:
  service: S3
  access_key_id: <%= Rails.application.credentials.aws[:access_key_id] %>
  secret_access_key: <%= Rails.application.credentials.aws[:secret_access_key] %>
  region: <%= Rails.application.credentials.aws[:region] %>
  bucket: <%= Rails.application.credentials.aws[:dev][:bucket] %>

amazon_prod:
  service: S3
  access_key_id: <%= Rails.application.credentials.aws[:access_key_id] %>
  secret_access_key: <%= Rails.application.credentials.aws[:secret_access_key] %>
  region: <%= Rails.application.credentials.aws[:region] %>
  bucket: <%= Rails.application.credentials.aws[:prod][:bucket] %>
```
- Finally, we add our services to `development.rb` and `production.rb`
```ruby
# config/environments/development.rb
config.active_storage.service = :amazon_dev
```
```ruby
# config/environments/production.rb
config.active_storage.service = :amazon_prod
```
- We did it! You should be able to attach files through the console, test it out.

```ruby
post = Post.first
file = File.open('app/assets/images/sennacy.jpg')
post.photo.attach(io: file, filename: 'sennacy.jpg')
post.photo.attached? # => true
```

### Image Preview
- Okay so what if we don't want our users to upload files via rails console? We need to be able to attach files from a form. Lets add something to our post form.
- To preview the file, we need to extract a url for it. On change of the file input component we instantiate a new [FileReader](https://developer.mozilla.org/en-US/docs/Web/API/FileReader) object. set a success function for when it loads
Then we ask it to read the file with [`FileReader#readAsDataURL(file)`](https://developer.mozilla.org/en-US/docs/Web/API/FileReader.readAsDataURL)

```javascript
const reader = new FileReader();
const file = e.currentTarget.files[0];
reader.onloadend = () =>
  this.setState({ imageUrl: reader.result, imageFile: file});

if (file) {
  reader.readAsDataURL(file);
} else {
  this.setState({ imageUrl: "", imageFile: null });
}
```
- Once it's loaded we can preview the image using the imageUrl we saved in state. Awesome!

### Image Uploading
- We still haven't sent the file to the server to be saved. To upload the file we will instantiate a new
[FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData) object.
We then use the [append](https://developer.mozilla.org/en-US/docs/Web/API/FormData/append)
method to add key/values to send to the server. One of the key/value pairs will be the binary
file we grab from `this.state.file`. Be mindful to have your keys match whatever your Rails
controller is expecting in the params. In our case this is `post[photo]`.

```javascript
handleSubmit(e) {
  e.preventDefault();
  const formData = new FormData();
  formData.append('post[title]', this.state.title);
  if (this.state.photoFile) {

    formData.append('post[photo]', this.state.photoFile);
  }
  $.ajax({
    url: '/api/posts',
    method: 'POST',
    data: formData,
    contentType: false,
    processData: false
  });
}
```
In the options for the `$.ajax` request we need to set `processData` and `contentType` both to
`false`. This is to prevent default jQuery behavior from trying to convert our FormData
object and sending up the wrong header. See more in this [SO post](http://stackoverflow.com/a/8244082).


### Configuring for production
- Last step. Heroku won't be able to unencrypt our `credentials.yml.enc` file unless we add our master key which can be found in `config/master.key`. But the master key is gitignored for good reason. ** Do not check this file in to git. ** We can use the heroku command line to secretly add the key to our heroku config.
```
$ heroku config:set RAILS_MASTER_KEY=<your-master-key-here>
```

### Default files and seeding
- Setting a default files and attaching files in your seeds are two things your project might need. Please discuss your implementation ideas for these features with your project manager to see if they have any helpful tips!
