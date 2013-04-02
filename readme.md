# Athenaeum

A simple meteor app for keeping track of books.

To run, first `git clone` the repo. Then, you'll need an API key at [isbndb.com](http://isbndb.com). Once you have that, go put it in the `config-sample.json` file, rename the file to `config.json`, and run the project with `meteor run --settings config.json` (you have to be in the project folder to do so). To deploy, you'll need to use `meteor deploy --settings config.json`.