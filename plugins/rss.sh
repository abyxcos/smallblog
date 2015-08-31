#!/bin/sh

make_rss(){
	link_ident='<h2 class="title">'

	echo "<?xml version=\"1.0\"?>"
	echo "<rss version=\"2.0\">"
	echo "<channel>"
	echo "<title>$title</title>"
	echo "<link>${site}${PREFIX}</link>"
	echo "<description>$title</description>"
	echo ""

	for post in `ls -r */*/*/*.md | head -n ${max_posts}`; do
		date=${post%/*}
		echo "<item>"
		echo "<title>`head -n 1 $post | sed 's/^#* //'`</title>"
		echo "<link>${site}${PREFIX}${post}.html</link>"
		# FIXME: Hardcode a time and timezone into the pubDate
		echo "<pubDate>${date//\//-} 00:00:00 +00:00</pubDate>"
		echo "<description>"
		grep '^tags: ' ${post}
		#markdown < "${post}" # FIXME: Special characters make RSS unhappy
		echo "</description>"
		echo "</item>"
		echo ""
	done

	echo "</channel>"
	echo "</rss>"
}

# Generate an rss feed of the front page
make_rss > feed.rss
