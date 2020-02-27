# Developers guide

## Releasing

* increase version number in lib/premonition/version.rb
* add release notes to HISTORY.md
* create a release and a tag in GitHub (optional)

  https://help.github.com/en/github/administering-a-repository/managing-releases-in-a-repository
  
* build new gem:
  
  ```gem build premonition.gemspec```
  
* push new version to rubygems.org:

  `gem push premonition-${version}.gem`
