# smallblog.lua
A small static blogging platform in the style of [jekyll](http://jekyllrb.com/)

Smallblog takes markdown files organized as `blog/year/month/day/post.md` and generates an index page containing the latest few posts, and a simple way to navigate all posts. Smallblog must be re-ran every time you add or modify a post to regenerate the site (in the spirit of static blogging.) An example site may be found [here](http://mnetic.ch/blog).

## Dependencies
Smallblog requires a markdown parser. I currently use and recommend [Discount](http://www.pell.portland.or.us/~orc/Code/discount/), which is written in C. If you're not familiar with markdown, there is a good tutorial on Wikipedia, available [here](http://en.wikipedia.org/wiki/Markdown).
### Lua libraries
* LuaPosix
* lyaml
* lua-discount
* lua-resty-template

Any lua markdown library that conforms to `post.html = markdown(post.text)` will currently work.

## Installation
    cd ~/public_html/
    mkdir blog
    cp -R static/ templates/ blog/
    mkdir tags
    cp smallblog.conf.sample blog/smallblog.conf
    echo "test" > blog/2013/08/16/test.md

Installation is simple. Just make a `blog` directory on your server, and copy the `static/` and `templates/` directories into it. File hierarchy under `blog` is in the form of `blog/year/month/date/post.md`. Posts must have a .md extension or they will be ignored. Multiple posts on the same date will be sorted by last modified timestamp (`ls -t`.)

## Usage
    cd ~/public_html/blog/
    lua smallblog.lua

To run smallblog, simply go to the folder that contains your blog, and run `smallblog` in that directory. It will generate the main page (`index.html`) in the current directory by parsing the date hierarchy folders for markdown (`.md`) files.

To use the tags features, include a `tags: ` line in your post followed by a list of tags to apply to your post.

## Configuration
Smallblog should be configured via the site specific smallblog.conf. The configuration for the [example site](http://mnetic.ch/blog) is provided in `smallblog.conf.sample`.

## Theming
Smallblog uses the same template system as jekyll. The default smallblog template is the jekyll default.

Posts take the format of:
```html
    <p><div class="post">
    <h3 class="title"><a href'/blog/year/month/day/post.html'>Title</a></h3>
    <p class="meta">Date: year-month-day time</p>
    <p>Post text</p>
    </div></p>
```

The site should be wrapped in a `<div class="site">` and contains the standard `<div class="header">`, `<div class="footer">`, and `<div class="contact">` for the header, footer, and footer contact information styling respectively. A `static/local.css` is provided to allow for minor changes without modifying the theme.

Smallblog also employs [lua-resty-template](https://github.com/bungle/lua-resty-template) to generate pages. Any of the `tmpl` files in `templates/` may be freely modified.

## Bugs
Smallblog.lua is a rewrite of smallblog.sh and smallblog.pl. It should still be largely compatible. Please file an issue if you find any bugs.

## License
Smallblog is released under the ISC (2-BSD) license. Please see [LICENSE](https://github.com/abyxcos/smallblog/blob/master/LICENSE) for the full text.
