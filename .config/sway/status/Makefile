build:
	go build

run:
	(echo '<html><body>'; go run . | sed -e 's/fgcolor/color/g;s/span/font/g' -u | while read line; do echo "<pre>$$line</pre>"; done ) | elinks
