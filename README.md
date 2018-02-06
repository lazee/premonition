# Premonition
Premonition is a [Jekyll](https://jekyllrb.com/) extension that makes it possible to add block-styled Markdown side content to your documentation, for example summaries, notes, hints or warnings.

It recognizes a special header in [block quotes](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes) and converts then into html before the Markdown parser
are run. As of now it only supports the [RedCarpet Markdown parser](https://github.com/vmg/redcarpet), but Kramdown support might be added in the future if requested.

## Features

 * Highly customizable
 * Non-intrusive - Content are rendered as block-quotes by any other parser
 * Easy to install

## Requirements

 * Jekyll 3.7.x or higher

## Installation

Add the following line to your `Gemfile` inside your Jekyll project. It should look something like this, depending on your Jekyll version:

```
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
  gem "premonition", "~> 1.0.0"
end
```

Then add Premonition to `plugins` inside the Jekyll config file (`_config.yml`):

```yaml
plugins:
    - premonition
```
