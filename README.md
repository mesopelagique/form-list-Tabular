# Tabular

[![Language][swift-shield]][swift-url]
[![check][check-shield]][check-url]

Present data as tabular view.

![screenshot](https://github.com/mesopelagique/Example-Tabular/raw/master/app.png)

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

Example in https://mesopelagique@github.com/mesopelagique/Example-Tabular

## How to use

Drop as first column an id or a the main column for data like a "name".

Then drop numbers columns.

### How to customize footer

You could edit the storyboard template to select footer computation.
By default the value is `sum`.You could add `min`, `max`, `avg`. (String value separated with comma)

With Xcode
![storyboard](https://github.com/mesopelagique/Example-Tabular/blob/master/customize.png?raw=true)

or in code
https://github.com/mesopelagique/form-list-Tabular/blob/master/Sources/Forms/Tables/___TABLE___/___TABLE___ListForm.storyboard#L184

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[swift-shield]: http://img.shields.io/badge/language-swift-orange.svg?style=flat
[swift-url]: https://developer.apple.com/swift/
[check-shield]: https://github.com/mesopelagique/form-list-Tabular/workflows/%E2%9C%85%20check/badge.svg
[check-url]: https://github.com/mesopelagique/form-list-Tabular/actions?query=workflow%3A%22%E2%9C%85+check%22
