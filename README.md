# smallblog
A small static blogging platform in the style of [jekyll](jekyllrb.com)

Smallblog takes markdown files organized as `blog/year/month/day/post.md` and generates an index page containing the latest few posts, and a simple way to navigate all posts. Smallblog must be re-ran every time you add or modify a post (in the spirit of static blogging.)

## Installation
    cd ~/public_html
    mkdir blog
    cp main.css blog/
    echo "test" > blog/2013/08/16/test.md

Installation is simple. Just make a `blog` directory on your server, and copy the `main.css` template into it. File hierarchy under `blog` is in the form of `blog/year/month/date/post.md`. Posts must have a .md extension or they will be ignored. Multiple posts on the same date will be sorted by last modified timestamp (`ls -t`.)

## Usage
    cd ~/public_html/blog
    smallblog

To run smallblog, simply go to the folder that contains your blog, and run `smallblog` in that directory. It will generate the main page (`index.html`) in the current directory by parsing the date hierarchy folders for markdown (`.md`) files.

## Configuration
Smallblog may be configured via the variables at the top of the file.
    out_file="index.html"  # The html file generated in your blog root
    title="blog" # The title of your blog

## Theming
Smallblog uses the same template system as jekyll. The default smallblog template is the jekyll default.

Posts take the format of:
    <p><div class="post">
    <h3 class="title"><a href'/blog/year/month/day/post.html'>Title</a></h3>
    <p class="meta">Date: year-month-day time</p>
    <p>Post text</p>
    </div></p>

The site should be wrapped in a `<div class="site">` and contains the standard `<div class="header">`, `<div class="footer">`, and `<div class="contact">` for the header, footer, and footer contact information styling respectively.

## Bugs
Smallblog was written under pdksh and tested under bash (both on linux.) It should be posix compliant, but please let me know if you find any bugs.

## License
Smallblog is released under the ISC license. Please see [LICENSE](https://github.com/abyxcos/smallblog/blob/master/LICENSE) for the full text.
