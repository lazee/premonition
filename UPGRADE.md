# Upgrading from 2.x to 4

In 4.0 you no longer need Font Awesome for the default box
types shipped with Premonition. So if you only have been using the default stylesheet, then it should be ok to remove
Font Awesome from your site, as long as you install the new stylesheet.

For everybody
-------------
In your Gemfile, make sure to upgrade Premonition itself

```
gem 'premonition', '4.0.0' 
```

Run
```
bundle update
```

Make sure to delete your old premonition (s)css file.
Install the new premonition.scss SASS stylesheet
```
bundle exec jekyll premonition-install
```

If you have custom templates
----------------------------
The default template has changed in 4.0, in order to support
the new default icons AND Font Awesome.

The main change is on how we include icons

```liquid
<i class="{% if meta.fa-icon %}fas {{meta.fa-icon}}{% else %}premonition {{meta.pn-icon}}{% endif %}"></i>
```

This might require some figgling on your end. So sorry about that!

Post an issue if you run into probems with this.
