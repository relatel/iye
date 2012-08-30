# i18n-yaml-editor

## Workflow

1. Create all new translation keys directly in the YAML files for at least one locale
2. `iye [path/to/locales]` - this loads the YAML files and creates missing keys for all locales
3. Point browser at [http://localhost:5050](http://localhost:5050)
4. Make changes
5. Press 'Save'
6. Use `git diff` to see the changes

## Todo

* Split `Key` up in `Key`/`Translation`
