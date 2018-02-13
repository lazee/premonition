# Premonition

**Note: This is the README for the upcoming v2. The old v1.x README can still be found [here](https://github.com/amedia/premonition/tree/v1.x). v2 will be released sometime in February 2018**

Premonition is a [Jekyll](https://jekyllrb.com/) extension that makes it possible to add block-styled Markdown side content to your documentation, for example summaries, notes, hints or warnings.

It looks for a custom header on the first line of [block quotes](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes) and converts it into html markup before the Jekyll Markdown parser are executed. As of now we only support the [RedCarpet Markdown parser](https://github.com/vmg/redcarpet), but Kramdown support might be added in the future if requested.

<p align="center">
<img src="https://github.com/amedia/premonition/raw/master/screen.png" height="450"/>
</p>

## Features

 * Highly customizable
 * Non-intrusive - Content are rendered as block-quotes by any other parser
 * Easy to install
 * Comes with a stylesheet (Sass/Css) you can embed onto your site.

## Requirements

 * Redcarpet
 * Jekyll 3.7.x or higher

 If you want to use the default template and stylesheet, you should also
 add Font Awesome to your site.

## Installation

Add the following line to your `Gemfile` inside your Jekyll project. It should look something like this, depending on your Jekyll version:

```
gem "redcarpet"
group :jekyll_plugins do
  gem "premonition", "~> 2.0.0"
end
```
As Premonition depends on Redcarpet, you must make sure this dependency is added as well. Also make sure that you have configured Jekyll to use Redcarpet:

```yaml
markdown: redcarpet
```

Then finally add Premonition to `plugins` inside the Jekyll config file (`_config.yml`):

```yaml
plugins:
    - premonition
```

## Usage

Premonition blocks are really just standard Markdown block quote where the first line must follow a
special format to activate the transformation.

`> [type] "Title"`

The type can be any letter string. It is used to map a block to its type configuration and/or css.
By default the type will be added as a class to the outer `<div>` of the
generated markup.

The *Title* is, as you might have guessed, the title that will be added to the block.

Example:

~~~markdown
> warning "I am a warning"
> The body of the warning goes here. Premonition also allow you to write `Markdown` inside the block.
~~~

This will be converted into something like this by Premonition

~~~html
<div class="premonition info"><div class="fa fa-check-square"></div><div class="content"><p class="header">Info</p><p>The body of the warning goes here. Premonition also allow you to write Markdown inside the block.</p></div></div>
~~~

The title can be omitted by providing an empty string. Like this:

~~~markdown
> warning ""
> No headers in here
~~~

Now you can add some CSS styling.

## Configuration

If you don't like the markup that Premonition produces, then you can change it in two ways.
Either by replacing the default template, or by configuring templates for each type.

All this are done inside your `_config.yml`

### Templates

Premonition use Liquid templates when rendering a block.

You have five variables available inside a template:

* *header* Boolean that tells you if a title exists and that a header should be added.
* *content* The rendered content for your block.
* *title* The block title.
* *type* The block type name.
* *meta* This is a hash that can contain any properties you would like to make available to your templates. It is configured in `_config.yml`

Our default template looks like this:

~~~html
<div class="premonition {{type}}">
  <div class="fa {{meta.fa-icon}}"></div>
  <div class="content">{% if header %}<p class="header">{{title}}</p>{% endif %}{{content}}</div></div>
~~~

#### Replacing the default template

You can override the default template like this in your `_config.yml`:

```yaml
premonition:
  default:
    template: 'Liquid template goes here'
```

### Adding custom types

You can customize each block type easily in your `_config.yml`. For each type you can

* Add a custom template (template)
* Set a default title (default_title)
* Set meta data that can be used in your template (meta)

Each type must be given a unique id (name).

~~~yaml
premonition:
  types:
    - id: custombox
      meta:
        fa-icon: fa-exclamation-circle
    - id: advanced
      template: 'Custom template her'
      default_title: 'MY BLOCK'
      meta:
        fa-icon: fa-exclamation-triangle
~~~

## Styling

Premonition comes with a stylesheet you can copy into to your project. Either
as a Sass file or as plain css. Read the [Jekyll Documentation](https://jekyllrb.com/docs/assets/) on how to add it.
You will find the resources file [here](https://github.com/amedia/premonition/tree/master/stylesheet)

In order to get the fancy icons you see in the screenshot, you will have to add this configuration to your `_config.yml`:

~~~yaml
premonition:
  types:
    - id: note
      meta:
        fa-icon: fa-check-square
    - id: info
      meta:
        fa-icon: fa-info-circle
    - id: warning
      meta:
        fa-icon: fa-exclamation-circle
    - id: error
      meta:
        fa-icon: fa-exclamation-triangle
~~~

And finally you will have to add [Font Awesome](https://fontawesome.com/) to your html header file.

The easiest way to do that is by using their free CDN:

~~~html
<script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>
~~~~

