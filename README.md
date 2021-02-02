# Premonition

[Demo site](https://lazee.github.io/premonition-demo/) ([Source code](https://github.com/lazee/premonition-demo))

Premonition is a higly customizable [Jekyll](https://jekyllrb.com/) plugin that can convert Markdown block-quotes into beautiful block styled content.

By simply adding a custom header to the first line of a [block quote](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#blockquotes), Premonition will transform it into a markup block of your choice.

<p align="center">
<img src="https://github.com/lazee/premonition/raw/master/screen.png" height="550"/>
</p>

## Features

- Highly customizable (Create your own styles and templates easily)
- Non-intrusive - Its just Markdown!
- Easy to install
- Comes with a default stylesheet (Sass/Css) and templates for beautiful messages boxes and citation.
- Font Awesome 5 support

## Version 4 Highlights

- Jekyll [Post Excerpts](https://jekyllrb.com/docs/posts/#post-excerpts) support
- New install command for the default stylesheet.
- [Kramdown reference links](https://kramdown.gettalong.org/quickref.html#links-and-images) support
- Jekyll 4 support (3.7 still supported)
- Added support for block attributes (See documentation further down)
- Added new citation block type.
- Minor fixes to the Premonition stylesheet.
- Removed the need Font Awesome css in default stylesheet, but
  Font Awesome is still supported.
- Other bug fixes. See HISTORY.md.

See UPGRADE.md for help on how to upgrade from 2.x to 4.0.

## Requirements

- Jekyll 3.7.x or higher (We recommend the new Jekyll 4)

## Installation

Add the following line to your `Gemfile` inside your Jekyll project folder:

```
group :jekyll_plugins do
  gem "premonition", "4.0.1"
end
```

Then add the the plugin to your `_config.yml`:

```yaml
plugins:
  - premonition
```

Now make sure to download the Premonition bundle:

```
bundle install
```

### Installing the default stylesheet

Finally, if you want to use the default Premonition styling (You really should!), then you have to install the SASS stylesheet.
Note: The installer expect you to have installed SASS support like it is described in the Jekyll documentation: https://jekyllrb.com/docs/step-by-step/07-assets/#sass.

From your Jekyll project folder, run:

```
bundle exec jekyll premonition-install
```

This will add the `premonition.scss` file to your `_sass` folder and ask if you want to import this file into your `assets/main.scss` file.
Both of these settings (destination folder and main file) can be configured. Run `bundle exec jekyll premonition-install --help` to see how.

If you prefer CSS, then download the stylesheet/premonition.css file directly from this repo.

## Usage

A Premonition block is really just a standard Markdown blockquote where the first line of the block must follow a certain syntax.

`> [type] "Title" [ attributes... ]`

The type must be set to one of the default Premonition block types, or a type
defined by you in `_config.yml`.

The default types are:

- note
- info
- warning
- error
- citation

The _Title_ will normally be the block header. Leave it empty to disable
the header.

_attributes_ are in use by the Citation type, but can be skipped for the other default types. See section about custom types for more info.

### Examples

Simple note with no header

```markdown
> note ""
> No headers in here
```

Note

```markdown
> note "I am a not"
> The body of the note goes here. Premonition allows you to write any `Markdown` inside the block.
```

Info

```markdown
> info "I am some info"
> The body of the info box goes here. Premonition allows you to write any `Markdown` inside the block.
```

Warning

```markdown
> warning "I am a warning"
> The body of the warning box goes here. Premonition allows you to write any `Markdown` inside the block.
```

Error

```markdown
> error "I am an error"
> The body of the error box goes here. Premonition allows you to write any `Markdown` inside the block.
```

Citation (Note the use of attributes here)

```markdown
> citation "Mark Twain" [ cite = "mt" ]
> I will be a beautiful citation quote
```

## Configuration

The templates can be customized in two eays. Either by replacing one of the default templates, or by adding a new type from scratch.

All this is done inside your `_config.yml`. Look at the [source code for our demo site](https://github.com/lazee/premonition-demo), for live examples on how configuration can be done.

### Templates

Like Jekyll itself, Premonition uses the [Liquid Markup Language](https://github.com/Shopify/liquid) for templating.

Six variables are available to the template engine:

- _header_ Boolean that tells you if a title exists and that a header should be added.
- _content_ The rendered content for your block.
- _title_ The block title.
- _type_ The type name (eg: note).
- _meta_ This is a hash that can contain any properties you would like to make available to your template. It is configured in `_config.yml`
- _attrs_ These are the attributes set in the block header. Like we did in the Citation example above.

Take a look at our default template inside `lib/premonition/resources.rb` to
get an idea of how this is done.

#### Overriding the default template

You can override the default template like this in your `_config.yml`:

```yaml
premonition:
  default:
    template: "Liquid template goes here"
```

#### Overriding the template for a default type

If you want to override the template for one of the default types (like note), do it like this:

```yaml
premonition:
  types:
    note:
      template: "Liquid template goes here"
```

### Adding custom types

Adding a custom type is just a matter of adding it to `_config.yml`. You can either override one
of the defaults, or add a new one.

For each type you can

- Add a custom template (template)
- Set a default title (default_title)
- Set meta data that can be used inside the template

Each type must have unique id (lowercase letters).

```yaml
premonition:
  types:
    custombox:
      meta:
        my-meta: "By myself"
    advanced:
      template: "Liquid template goes here"
      default_title: "MY BLOCK"
      meta:
        my-meta: "By myself"
```

## More on styling

As described in the Installation section above, it is pretty easy to install the default stylesheet into your project.
But we recognize that this design probably isn't a perfect fit for everybody. Luckily you can modify it :)

Our recommendation is to install the default stylesheet and override it in another SASS file. This way it will be
easy to upgrade the default Stylesheet later without loosing your changes.

The [Jekyll Documentation](https://jekyllrb.com/docs/assets/) describes the process of adding your own SASS files in great details.

## Font Awesome support

Premonition 4.x no longer depends on Font Awesome for its default stylesheet.
But it is still supported.

To add Font Awesome support you should add something like this
to your head template file:

```
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.12.1/css/all.css">
```

Feel free to install it any other way you prefer, as long as you follow their
[license](https://fontawesome.com/license/free).

Now you can swith to Font Awesome for any of the default types by adding
`fa-icon` to a types meta object. Let's say you want to replace the default error box icon with the beautiful `fa-bug` icon from Font Awesome.

Then just add this to your `_config.yml`:

```yml
premonition:
  types:
    error:
      fa-icon: "fa-bug"
```

Simple as that :)
