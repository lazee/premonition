# Premonition
Premonition is a [Jekyll](https://jekyllrb.com/) extension that makes it possible to add block-styled Markdown side content to your documentation, for example summaries, notes, hints or warnings.

It recognizes a special header in [block quotes](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes) and converts then into html before the Markdown parser
are run. As of now it only supports the [RedCarpet Markdown parser](https://github.com/vmg/redcarpet), but Kramdown support might be added in the future if requested.

## Features

 * Highly customizable
 * Non-intrusive - Content are rendered as block-quotes by any other parser
 * Easy to install

## Requirements

 * Redcarpet
 * Jekyll 3.7.x or higher

## Installation

Add the following line to your `Gemfile` inside your Jekyll project. It should look something like this, depending on your Jekyll version:

```
gem "redcarpet"
group :jekyll_plugins do
  gem "premonition", "~> 1.0.0"
end
```
As Premonition depends on Redcarpet, you must make sure this dependency is added as well.

Then add Premonition to `plugins` inside the Jekyll config file (`_config.yml`):

```yaml
plugins:
    - premonition
```

## Usage

Premonition blocks are really just standard Markdown block quote where the first line must follow a
special format to activate the transformation.

`> [type] "Title"`

The type can be any letter string. It is used to map a block to type configuration. This enables
you to customize the look of different types. Like *Info*, *Warning* and *Error* boxes for example.
By default the type will be added to the surrounding `<div>` block of the generated html code.

The *Title* is as you might have guessed the title that will be added to the block.

Example:

~~~markdown
> warning "I am a warning"
> The body of the warning goes here. Premonition also allow you to write Markdown inside the block.
~~~

This will be converted into something like this bu Premonition

~~~html
<div class="premonition warning">
  <span class="header">Info</span>
  <p>The body of the warning goes here. Premonition also allow you to write Markdown inside the block.</p>
~~~

The title can be omitted by providing an empty string . Like this:

~~~markdown
> warning ""
> No headers in here
~~~

Now you can add some CSS styling.

## Configuration

If you don't like the markup that Premonition produces, then you can change it in two ways.
Either by replacing the default template, or by configuring templates for each type.

All this are done inside your `_config.yml`

### Replacing the default template

```yaml
premonition:
  default:
    template: '<div></i>%{header}%{content}</div>'
    header_template: '<span class="header">%{title}</span>'
```

Please be aware of the placeholders inside the template. These placeholders will be replaced with
the actual content of your block.

Available placeholders are

* *header* This is where the content from the header_template will be added if the title is not empty.
* *content* This is where the rendered content of your block quote are added.
* *title* This is where you block title will be added.
* *type* The type name of the block.

### Adding custom types

Sometimes you might want to have different markup for different block types. This can easily be done
by adding types to your Premonition configuration inside `_config.yml`

~~~yaml
premonition:
  default:
    template: '<div></i>%{header}%{content}</div>'
    header_template: '<span class="header %{type}">%{title}</span>'
  types:
    - id: tip
      template: '<div class="alert alert-success" role=""><i class="fa fa-check-square-o"></i>%{header}%{content}</div>'
    - id: note
      template: '<div class="alert alert-info" role="alert"><i class="fa fa-info-circle"></i>%{header}%{content}</div>'
~~~

NOTE: You cannot add a custom header_template to types at the moment. This will be fixed soon.

#### Default titles

You can add a default title to a type.

~~~yaml
- id: tip
      template: '<div class="alert alert-success" role=""><i class="fa fa-check-square-o"></i>%{header}%{content}</div>'
      default_title: 'TIP!'
~~~

