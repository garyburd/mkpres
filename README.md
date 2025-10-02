# mkslides

Pandoc filter and template for converting Markdown to an HTML presentation.


	pandoc -t html5 --section-divs --template=mkslides/template.html --lua-filter=mkslides/filter.lua -o index.html index.md


Yes, I know that Pandoc has builtin support for slides. This was fun.
