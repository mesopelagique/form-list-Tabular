# Tabular

Present data as tabular view.

* **Type:** Collection

## Limitations

* **Section:** not available
* **Search:** not available
* **Actions:**  not available
* **Transition to detail form:**  not available

## How to integrate

* To use a list form template, the first thing you'll need to do is create a YourDatabase.4dbase/Resources/Mobile/form/list folder.
* Then drop the list form folder into it.

For instance with git go to your database folder

```bash
cd YourDatabase.4dbase/Resources/Mobile/form/list
```

If your project is not a git repository, just clone

```bash
git clone https://github.com/mesopelagique/form-list-Tabular.git Tabular
```

otherwise use a submodule

```bash
git submodule add https://github.com/mesopelagique/form-list-Tabular.git Tabular
```

## How to use

Drop as first column an id or a the main column for data like a "name".

Then drop numbers columns.

### How to customize footer

You could edit the storyboard template to select footer computation.
By default the value is `sum`.You could add `min`, `max`, `avg`. (String value separated with comma)
