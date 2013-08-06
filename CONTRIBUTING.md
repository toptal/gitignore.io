## Vision

The vision for gitignore.io is to become the authritaitve source for .gitignore templates.  Right now gitignore provides templates for Operating Systems, IDE's and Programming Languages, but can eventually grow to encompass other creative spaces as well.

## Ways You Can Help

1. __Add Templates__ - Add more Programming Langauges, Operating Systems and IDE's
2. __Organize Files__ - Help organize the files of the system into categories that will make it easier for new comers to contribute templates 
3. __Windows Command Line__ - Find a way to make the command line call run on Windows
4. __Explore__ -  Git it used primarily used by software engineers but there might be other disciplines which may have workflows that could be improved by using Git


## Adding/Updating Templates

* If you want to contirbute a new .gitignore template, please add the file to custom template directory.  

  ```sh
  cd ./data/gitignore/Custom
  ```

* If you are editing an existing template, make changes in the template and submit a pull request.

## Organizing Files

Creating new directories to help contributors as the list gets larger.  The current format is based on GitHubs gitignore template system, but could be improved

```
// Suggested Directory Structure
├ data
└── gitignore
    ├── opsys
    ├── porglang
    ├── ide
    └── // New template category
```
## Windows Command Line

Looking for a clean way to implement executing the `gi` command from the command line.  With Linux and OSX, it's currently implemented though a function that takes a parameter to curl.

```sh
function gi() { 
   curl http://gitignore.io/api/\$@;
}
```

## Explore

Looking for new .gitignore template categories.  Other disciplines that may start using git could be designers, architects, and writers.  Creating template categories to ignore metadata created by their tools is what this section is desgined for.
