# Premonition

[Demo site](https://lazee.github.io/premonition-demo/) ([Source code](https://github.com/lazee/premonition-demo))

Premonition is a higly customizable [Jekyll](https://jekyllrb.com/) plugin that can convert Markdown block-quotes into beautiful block styled content. 

By simply adding a custom header to the first line of a [block quote](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes), Premonition will transform it into a markup block of your choice.

<p align="center">
<img src="https://github.com/lazee/premonition/raw/master/screen.png" height="450"/>
</p>

## Features

 * Highly customizable (Create your own styles and templates easily)
 * Non-intrusive - Its just Markdown!
 * Easy to install
 * Ships with a stylesheet (Sass/Css) and templates for beautiful messages boxes and citation.

 ## Version 4 Highlights

 * Jekyll [Post Excerpts](https://jekyllrb.com/docs/posts/#post-excerpts) support
 * New install command for default stylesheets.
 * [Kramdown reference links](https://kramdown.gettalong.org/quickref.html#links-and-images) support
 * Jekyll 4 support (nut 3.7 still supported)
 * Added support for block attributes (See documentation further down)
 * Added new citation block type.
 * Minor fixes to the Premonition stylesheet.
 * Removed the need for external font css in default styles.
 * Other bug fixes. See HISTORY.md.
 
## Requirements

 * Jekyll 3.7.x or higher (We recommend the new Jekyll 4)
 
## Installation

Add the following line to your `Gemfile`:

```
group :jekyll_plugins do
  gem "premonition", "~> 4.0.0"
end
```

Then acticate the the plugin in your `_config.yml`:

```yaml
plugins:
    - premonition
```

Now run 

```
bundle install
```

### Installing the default stylesheet

Finally, if you want to use the standard Premonition styling, you should install the Premonition SASS file into your project.
Open a terminal and go to the root folder of your Jekyll project, and run.

```
bundle exec jekyll premonition-install
```

This will add a `premonition.scss` file to your `_sass` folder and ask if you want to import this file into your `assets/main.scss` file.
Both of these settings (destination folder and main file) can be configured. Run `bundle exec jekyll premonition-install --help` to see how.

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
<div class="premonition info"><i class="fas fa-check-square"></i><div class="content"><p class="header">Info</p><p>The body of the warning goes here. Premonition also allow you to write Markdown inside the block.</p></div></div>
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
    note:
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
    custombox:
      meta:
        fa-icon: fa-exclamation-circle
    advanced:
      template: 'Liquid template goes here'
      default_title: 'MY BLOCK'
      meta:
        fa-icon: fa-exclamation-triangle
~~~

## More on styling

As described in the Installation section above, it is pretty easy to install the default stylesheet into your project.
But we recognize that this design probably isn't a perfect fit for everybody. Luckily you can modify it :)

Out recommendation is to install the default stylesheet and override it in another SASS file. This way it will be
easy to upgrade the default Stylesheet later without loosing your changes.

The [Jekyll Documentation](https://jekyllrb.com/docs/assets/) describes the process of adding your own SASS files in great details.
