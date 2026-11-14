#!/usr/bin/env bash
set -euo pipefail #changes how bash handles errors

cat <<'HTML' #cat - prints the following lines and >>html tells bash to leave the contents literal


<!doctype html>
<html lang="fi">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="system_stats_viewer.css">
  <title>Järjestelmän tila</title>
</head>
<body class="status-page">
<pre class="status-output">
HTML

bash ./system_stats.sh | #runs script, pipe send the output to the next command
 #"sed" stands for stream editor. It reads text, applies edits, and prints the result. 
 #In the script, it reads the output piped from it and makes changes
  sed -E $'s/\x1b\\[[0-9;]*m//g' | #removes the terminal formatting codes used for bold, cyan, and reset, 
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' #turns &, <, and > into &amp;, &lt;, and &gt

printf '\n</pre>\n</body>\n</html>\n' #writes each closing tag on its own line.
