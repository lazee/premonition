# Developers guide

## Development

In order to being able to code inside this project you will need to:

- Install a Ruby version greater than 2.5 (rbenv is a great choice)
- Install Bundler (gem install bundler)

  - Inside the premonition folder run `bundle install --jobs 4 --retry 3`. This will install the needed dependencies.

- Prefer developing in Visual Studio code with these plugins

  - EditorConfig for VS Code
  - Ruby by Peng Lv
  - VSCode Ruby by Stafford Brunk
  - ruby-rubocop ny misogi

## Running the tests

```
bundle exec rake test
```

from the root of the Premonition repo.

## Releasing

- increase version number in lib/premonition/version.rb
- add release notes to HISTORY.md
- create a release and a tag in GitHub (optional)

  https://help.github.com/en/github/administering-a-repository/managing-releases-in-a-repository

- build new gem:

  `gem build premonition.gemspec`

- push new version to rubygems.org:

  `gem push premonition-${version}.gem`
