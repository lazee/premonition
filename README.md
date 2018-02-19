# Premonition

**DEMO: https://amedia.github.io/premonition-demo/ ([Source code](https://github.com/amedia/premonition-demo))**

Premonition is a [Jekyll](https://jekyllrb.com/) extension that makes it possible to add block-styled content to your site in plain Markdown.

By adding a special header to the first line of a [block quote](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes),
Premonition will transform it into a markup block of your choice.

<p align="center">
<img src="https://github.com/amedia/premonition/raw/master/screen.png" height="450"/>
</p>

## Features

 * Highly customizable (Create your own styles and templates easily)
 * Non-intrusive - Content are presented as block-quotes by any other renderer.
 * Easy to install
 * Comes with a stylesheet (Sass/Css) and templates for rendering typical information boxes.
 * Support for both Kramdown and RedCarpet.

## Requirements

 * Jekyll 3.7.x or higher
 * FontAwesome 4.x (If you are using the default template and styles)

## Installation

Add the following line to your `Gemfile`:

```
group :jekyll_plugins do
  gem "premonition", "~> 2.0.0"
end
```

Then add Premonition to `plugins` in `_config.yml`:

```yaml
plugins:
    - premonition
```

Finally run `bundle install`

## Usage

Premonition blocks are really just a standard Markdown blockquote where the first line must be on a
special format to activate the transformation.

`> [type] "Title"`

The type can be any letter string. It is used to map a block to its type configuration and/or css.
By default the type will be added as a class to the outer `<div>` of the
generated markup.

Default types are:

* note
* info
* warning
* error

The *Title* is the box header. It can be left empty to disable the box header:

~~~markdown
> warning ""
> No headers in here
~~~

Example:

~~~markdown
> warning "I am a warning"
> The body of the warning goes here. Premonition allows you to write any `Markdown` inside the block.
~~~

Premonition will then convert this into something like:

~~~html
<div class="premonition info"><div class="fa fa-check-square"></div><div class="content"><p class="header">Info</p><p>The body of the warning goes here. Premonition also allow you to write Markdown inside the block.</p></div></div>
~~~

You can change the markup into anything you like by adding your own template.

## Configuration

The templates can be customized in two eays. Either by replacing the default template, or by adding a custom template to a type.

All this is done inside your `_config.yml`.

### Templates

Like Jekyll itself, Premonition uses the [Liquid Markup Language](https://github.com/Shopify/liquid) for its templates.

Five variables are available to the template engine:

* *header* Boolean that tells you if a title exists and that a header should be added.
* *content* The rendered content for your block.
* *title* The block title.
* *type* The type name (eg: note).
* *meta* This is a hash that can contain any properties you would like to make available to your template. It is configured in `_config.yml`

Our default template:

~~~html
<div class="premonition {{type}}">
  <div class="fa {{meta.fa-icon}}"></div>
  <div class="content">{% if header %}<p class="header">{{title}}</p>{% endif %}{{content}}</div></div>
~~~

#### Overriding the default template

You can override the default template like this in your `_config.yml`:

```yaml
premonition:
  default:
    template: 'Liquid template goes here'
```

#### Overriding the template for a default type

If you want to override the template for one of the default types (like note), do it like this:

```yaml
premonition:
  types:
    - id: note
      template: 'Liquid template goes here'
```

### Adding custom types

Adding a custom type is just a matter of adding it to `_config.yml`. You can either override one
of the defaults, or add a new one.

For each type you can

* Add a custom template (template)
* Set a default title (default_title)
* Set meta data that can be used inside the template

Each type must have unique id (lowercase letters).

~~~yaml
premonition:
  types:
    - id: custombox
      meta:
        fa-icon: fa-exclamation-circle
    - id: advanced
      template: 'Liquid template goes here'
      default_title: 'MY BLOCK'
      meta:
        fa-icon: fa-exclamation-triangle
~~~

## Styling

Premonition comes with a stylesheet you can copy into to your project. Either
as a Sass file or as plain css. The [Jekyll Documentation](https://jekyllrb.com/docs/assets/) describes the process in great details.

Download the stylesheet from here : https://github.com/amedia/premonition/tree/master/stylesheet

In order to get the fancy icons, you will have to add [Font Awesome](https://fontawesome.com/) to your html header file.
Be aware that you have to use v4.x of Font Awesome together with our CSS.

The easiest way to get startet with Font Awesome is to add this to your html header file:

~~~html
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
~~~~

