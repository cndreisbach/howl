# Howl

Howl is a tiny static site generator.

## File structure

    /pages
      index.html
      about.html
    /posts
      first-post.html
      my-cat-died.html
    /templates
      default.html
      alternate.html
    /site
      <generated files go here>

### Changing the date format

In `config.yml` add a line similar to the following:

    date_format: "%Y-%m-%d, at %I:%M %p"

The above format renders like this:

    2010-10-18, at 02:18 PM

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Clinton R. Nixon. See LICENSE for details.
