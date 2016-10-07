-- TODO: 
--  - Error out if tags/ doesn't exist
--
local posix		= require "posix"				-- LuaPosix
local sys_stat	= require "posix.sys.stat"	-- LuaPosx
local yaml		= require "lyaml"
local markdown	= require "discount"
local template	= require "resty.template"

local utils = {}
-- open and read a file into a string
function utils.readFile( path )
	local f			= assert( io.open( path, 'r' ) )
	local contents	= assert( f:read( '*a' ) )
	f:close()
	return contents
end
-- open and write a file from a string
function utils.writeFile( path, s )
	local f = assert( io.open( path, 'w+' ) )
	assert( f:write( s ) )
	f:close()
	return true
end
-- string.gsub with captures
-- returns capture,original
function utils.cgsub( s, pattern, replace )
	c = s:match( pattern )
	s = s:gsub( pattern, replace )
	return c,s
end
-- sort a hash table into an array
function utils.tsort( t )
	local array = {}
	for k,v in pairs( t ) do table.insert( array, k ) end
	table.sort( array )
	return array
end

local function parsePost( path )
	-- Post data structure
	local tags = ""
	local post = {
		path = path,
		text	= "",		html = "",
		title	= "",		tags = {},
		date	= "", 	edit_date = "",
	}

	-- Grab date from path
	local year, month, day = path:match( "(%d+)/(%d+)/(%d+)/.*%.md" )
	-- Ignore files not in the proper hierarchy
	if year == nil or month == nil or day == nil then return nil end
	-- Grab the mtime
	local fattr = sys_stat.stat( path )
	-- Format the dates to YYYY-MM-DD
	post.date		= string.format( "%s-%s-%s", year, month, day )
	post.edit_date	= os.date( "%Y-%m-%d", fattr.st_mtime )

	-- Read in post
	post.text = utils.readFile( path )

	-- Get post title
	post.title, post.text = utils.cgsub( post.text, "^# (.-)\n", "" )
	-- Get post tags
	tags, post.text = utils.cgsub( post.text, "tags: (.-)\n", "" )
	-- Index tags and append them to the global hash
	for tag in (tags or ""):gmatch( "%g+" ) do
		table.insert( post.tags, tag )
		site.tags[tag] = true
	end

	-- Convert the text to markdown
	post.html = markdown( post.text )

	-- Return the structure
	return post
end


-- Read in the site configuration
site = yaml.load( utils.readFile( "smallblog.conf" ) )
site.tags = {}
-- Grab all posts in the form of YYYY/MM/DD/post.md
local paths = posix.glob( "*/*/*/*.md" )
-- Sort posts in reverse order (newest first)
table.sort( paths, function(a,b) return a > b end )

-- Generate the individual posts.md.html and save posts
local posts			= {}
local indexPosts	= {}
local view			= template.new( "templates/post_page.tmpl" )
for _,path in ipairs( paths ) do
	post = parsePost( path )
	if #indexPosts < site.max_posts then table.insert( indexPosts, post ) end
	if post then
		table.insert( posts, post )

		view.site	= site
		view.post	= post
		utils.writeFile( path..".html", tostring( view ) )
	end
end

-- Generate index.html
do
	view			= template.new( "templates/index.tmpl" )
	view.site	= site
	view.posts	= indexPosts
	utils.writeFile( "index.html", tostring( view ) )
end

-- Generate archive.html
do
	view			= template.new( "templates/archive_page.tmpl" )
	view.site	= site
	view.posts	= posts
	view.title	= "Archives"
	utils.writeFile( "archive.html", tostring( view ) )
end

-- Generate tags.html
do
	view			= template.new( "templates/tag_index.tmpl" )
	-- Sort tags
	site.tags	= utils.tsort( site.tags )
	view.site	= site
	view.title	= "Tags"
	utils.writeFile( "tags.html", tostring( view ) )
end

-- Generate tags/$tag.html
view = template.new( "templates/tag_page.tmpl" )
for _,tag in ipairs( site.tags ) do
	-- TODO: clean out stale tags in tags/
	local tagList = {}
	for _,post in ipairs( posts ) do
		if table.concat( post.tags ):match( tag ) then
			table.insert( tagList, post )
		end
	end

	view.site	= site
	view.posts	= tagList
	view.title	= tag
	utils.writeFile( "tags/"..tag..".html", tostring( view ) )
end

-- Generate feed.rss
do
	view			= template.new( "templates/rss.tmpl" )
	view.site	= site
	view.posts	= posts
	utils.writeFile( "feed.rss", tostring( view ) )
end
