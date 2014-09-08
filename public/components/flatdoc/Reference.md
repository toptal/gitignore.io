Flatdoc
=======

Basic Flatdoc module.

The main entry point is `Flatdoc.run()`, which invokes the [Runner].

```js
Flatdoc.run({
  fetcher: Flatdoc.github('rstacruz/backbone-patterns');
});
```



### Flatdoc.run()

Creates a runner.
See [Flatdoc].

### Flatdoc.file()

File fetcher function.

Fetches a given `url` via AJAX.
See [Runner#run()] for a description of fetcher functions.

### Flatdoc.github()

Github fetcher.
Fetches from repo `repo` (in format 'user/repo').

If the parameter `filepath` is supplied, it fetches the contents of that
given file in the repo.

See [Runner#run()] for a description of fetcher functions.

See: http://developer.github.com/v3/repos/contents/

Parser
------

Parser module.
Parses a given Markdown document and returns a JSON object with data
on the Markdown document.

```js
var data = Flatdoc.parser.parse('markdown source here');
console.log(data);
```

  
```js
data == {
  title: 'My Project',
  content: '<p>This project is a...',
  menu: {...}
}
```



### Parser.parse()

Parses a given Markdown document.
See `Parser` for more info.

Transformer
-----------

Transformer module.
This takes care of any HTML mangling needed.  The main entry point is
`.mangle()` which applies all transformations needed.

```js
var $content = $("<p>Hello there, this is a docu...");
Flatdoc.transformer.mangle($content);
```

If you would like to change any of the transformations, decorate any of
the functions in `Flatdoc.transformer`.

### Transformer.mangle()

Takes a given HTML `$content` and improves the markup of it by executing
the transformations.

> See: [Transformer](#transformer)

### Transformer.addIDs()

Adds IDs to headings.

### Transformer.getMenu()

Returns menu data for a given HTML.

```js
menu = Flatdoc.transformer.getMenu($content);
menu == {
  level: 0,
  items: [{
    section: "Getting started",
    level: 1,
    items: [...]}, ...]}
```



### Transformer.buttonize()

Changes "button >" text to buttons.

### Transformer.smartquotes()

Applies smart quotes to a given element.
It leaves `code` and `pre` blocks alone.

Highlighters
------------

Syntax highlighters.

You may add or change more highlighters via the `Flatdoc.highlighters`
object.

```js
Flatdoc.highlighters.js = function(code) {
};
```

Each of these functions

### Highlighters.js

JavaScript syntax highlighter.

Thanks @visionmedia!

MenuView
--------

Menu view. Renders menus

Runner
------

A runner module that fetches via a `fetcher` function.

```js
var runner = new Flatdoc.runner({
  fetcher: Flatdoc.url('readme.txt')
});
runner.run();
```

The following options are available:

 - `fetcher` - a function that takes a callback as an argument and
   executes that callback when data is returned.

See: [Flatdoc.run()]

### Runner#run()

Loads the Markdown document (via the fetcher), parses it, and applies it
to the elements.

### Runner#applyData()

Applies given doc data `data` to elements in object `elements`.


[Flatdoc]: #flatdoc
[Flatdoc.run()]: #flatdoc-run
[Flatdoc.file()]: #flatdoc-file
[Flatdoc.github()]: #flatdoc-github
[Parser]: #parser
[Parser.parse()]: #parser-parse
[Transformer]: #transformer
[Transformer.mangle()]: #transformer-mangle
[Transformer.addIDs()]: #transformer-addids
[Transformer.getMenu()]: #transformer-getmenu
[Transformer.buttonize()]: #transformer-buttonize
[Transformer.smartquotes()]: #transformer-smartquotes
[Highlighters]: #highlighters
[Highlighters.js]: #highlighters-js
[MenuView]: #menuview
[Runner]: #runner
[Runner#run()]: #runner-run
[Runner#applyData()]: #runner-applydata
