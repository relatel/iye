# Iye

Iye - short for i18n yaml editor - makes it easy to translate your Rails I18N files and 
keep them up to date. Unlike a lot of other tools in this space, IYE works directly on the
YAML files instead of keeping a separate database in sync. This has several benefits:

* Branching and diffing is trivial
* It does not alter the workflow for developers etc., whom can continue editing the
  YAML files directly
* If your YAML files are organized in subfolders, this structure is kept intact

## Prerequisites

You need to understand a few things about IYE for it to make sense, mainly:

* IYE does not create new keys - keys must exist for at least one locale in the YAML files
* IYE does not create new locales - at least one key must exist for each locale in the YAML files

## Workflow

1. Install IYE:
      
        $ gem install iye

2. Navigate to the folder containing your YAML files and start IYE:
    
        $ iye .

    At this point IYE loads all translation keys for all locales, and creates any
    keys that might be missing for existing locales.
  
3. Point browser at [http://localhost:5050](http://localhost:5050)
4. Make changes and press 'Save' - each time you do this, all the keys will be
   written to their original YAML files, which you can confirm e.g. by using
   `git diff`.

## Development

The source ships with a `config.ru` suitable for development use with `shotgun(1)`:
    
    shotgun -p 5050

