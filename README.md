Huntsville's consultants, moonlighters, service firms and business advisors.

# Getting Started

## Install Ruby, Ruby Gems, PostgreSQL and Pakyow

- [Ruby 2.47](http://www.ruby-lang.org/en/downloads/)
- [Ruby Gems](http://rubygems.org/pages/download)
- [PostgreSQL](http://www.postgresql.org/)
- `gem install pakyow`

## Set up DB

- Create Postgres DB
- Copy .env.example to .env and edit to contain your Postgres peoplename, password and database
  - You can also us the url in the Slack channel
- From the hntsvll directory, run the rake reset `bundle exec rake db:reset`

## Running the application

Start the app server in the command line:

  `bundle exec pakyow server`

You'll find your app running at [http://localhost:3000](http://localhost:3000)!

## Creating data

- In the dev environment, go to [http://localhost:3000/people/new](http://localhost:3000/people/new)
- Fill out the form and submit
- Go to [http://localhost:3000/logout](http://localhost:3000/logout)
- Repeat

## Need to interact with your app? Fire up a console:

  `pakyow console`

# Contributing code

1. Create a Github [issue](https://github.com/OpenHuntsville/hntsvll/issues)
2. If you don't already have one, generate an SSH key and add it to your Github profile. [Documentation here.](https://help.github.com/articles/generating-ssh-keys/)
3. On your local machine, clone the repository `git@github.com:OpenHuntsville/hntsvll.git` if you have not already. If you have, switch to the "master" branch and get the newest version of the code. There are Git GUIs that you can use or you can open up terminal, go to the repo directory, and `git checkout master && git pull`.
4. Create and checkout a new branch with issue number and title as the branch name. The terminal command for creating and checking out a branch is `git checkout -b 01-this-is-the-title`. When you create a branch, it bases it off of the branch you were in when you created it, so be sure to `git checkout master && git pull` before creating a new branch to make life easer when you need to contribute the branch. [More on the feature branch workflow.](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
5. Run the server; edit files; test your changes; and repeat.
6. As you make changes, and especially when you are happy with them, you'll need to add and commit the changes to your branch. You can add individual files or all changes. From the terminal, `git add filename.ext` will stage individual files and `git add .` will stage all changes in the current directory and subdirectories.
7. To see what files are staged to be committed, do a `git status` in the terminal. You can also do a `git diff` to see changes, line by line.
8. Committing the changes is what captures the changes in history. In the terminal, the format I like to use to commit and add a comment/commit **m**essage is `git commit -m "Overview of what I changed and/or how I changed it"`.
9. Just in case someone has changed the "master" branch since you created your branch, you need to pull master and merge it over the top of your changes. In the terminal: `git checkout master && git pull && git checkout 01-this-is-the-title && git merge master`. Your GUI or the terminal will tell you if there are conflicts and where they are and that you'll need to fix them and repeat steps #6-8.
10. For others to see your changes, you will need to push to Github. In the terminal, `git push -u origin 01-this-is-the-title` creates the branch in the origin (Github) repository and uploads your changes.
11. Before you merge your changes to the "master" branch, create a pull request through the Github website. The pull request shows the changes you made and allows others to review your code and approve or deny. When the reviewer(s) has/have approved your changes, you can merge through a button. _If someone makes a change to Master before you can, you'll need to repeat step #9._


# Next Steps

The following resources might be handy:

- [Website](http://pakyow.com)
- [Warmup](http://pakyow.com/warmup)
- [Docs](http://pakyow.com/docs)
- [Code](http://github.com/metabahn/pakyow)
- [Tech256](http://www.tech256.com)