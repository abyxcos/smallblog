#!/bin/sh

make_tags(){
	rm tags/*/*		# Delete all the post symlinks
	rm tags/index.html	# Delete the hanging tags index
	rmdir tags/*		# Delete all the tags

	for post in `ls -r */*/*/*.md`; do
		# Grab tags from the tags: line in the post
		tags=`grep '^tags: ' "${post}"`
		for tag in ${tags/#tags: /}; do
			mkdir -p "tags/${tag}"
			ln -s "../../${post}" "tags/${tag}/${post##*\/}"
			ln -s "../../${post}.html" "tags/${tag}/${post##*\/}.html"
		done
		# Generate the tag page
		make_index "tags/${tag}" "${tag}" > "tags/${tag}/index.html"
		# Rewrite the tags: line to include links
		sed "/tags: / s| \([A-Za-z0-9]*\)| <a class=\"meta\" href=\"${PREFIX}/tags/\1\">\1</a>|2g" "${post}.html" | tee "${post}.html" > /dev/null
	done
}

# Generate the tags index page
make_tags_index(){
	echo "${blog_header/\%TITLE\%/tags}"
	echo "<h2>Tags:</h2>"
	echo "<ul class=\"posts\">"

	for tag in `ls tags`; do
		[ -d "tags/${tag}" ] && echo "<li><a href=\"${tag}\">${tag}</a></li>"
	done

	echo "</ul>"
	echo "${blog_footer}"
}

# Generate the tags directory structure and index pages
if [ -d tags ]; then
	make_tags
	for tag in `ls -r tags`; do
		make_index "tags/${tag}" "${tag}" > "tags/${tag}/index.html"
	done
	make_tags_index > tags/index.html
	# Look only at the tags: line
	# Grab only [alphanum and -] preceded by a space and reformat the grouped match
	# Ignore the first match; proceed with the second onwards
	sed '/tags: / s| \([A-Za-z0-9\-]*\)| <a class="meta" href="tags/\1">\1</a>|2g' index.html > index.html.tagged
	mv index.html.tagged index.html
fi
