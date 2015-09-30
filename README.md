# Translator [ ![Codeship Status for Sage/translator](https://codeship.com/projects/8f0b6800-4996-0133-8527-667b3b8a5886/status?branch=master)](https://codeship.com/projects/105641)

Translator is based on [IYE](https://github.com/firmafon/iye).
Translator makes it easy to translate your Rails I18N files and keep them up to date.
YAML files instead of keeping a separate database in sync. This has several benefits:

* Branching and diffing is trivial
* It does not alter the workflow for developers etc., whom can continue editing the
  YAML files directly
* If your YAML files are organized in subfolders, this structure is kept intact

![Translator](https://cloud.githubusercontent.com/assets/2951339/10191908/9e6cd5a8-6778-11e5-8824-f512d394ca25.png)

## Prerequisites

You need to understand a few things about Translator for it to make sense, mainly:

* Translator does not create new keys - keys must exist for at least one locale in the YAML files
* Translator does not create new locales - at least one key must exist for each locale in the YAML files

## Workflow

1. Install Translator:

        $ git clone git@github.com:Sage/translator.git
        $ cd translator
        $ gem build translator.gemspec
        $ gem install translator-1.1.1.gem

2. The `translator` executable is now available, use it wherever you want.

        $ translator path/to/your/i18n/locales [port]

    At this point Translator loads all translation keys for all locales, and creates any
    keys that might be missing for existing locales, the default port is 5050

3. Point browser at [http://localhost:5050](http://localhost:5050)
4. Make changes and press 'Save' - each time you do this, all the keys will be
   written to their original YAML files.
5. Review your changes before committing files, e.g. by using `git diff`.
