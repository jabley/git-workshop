# Exercise 4 - Rebasing Branches onto Other Branches

This exercise explores rebasing branches onto other branches.

## Setup

This exercise starts from where exercise 3 finishes.

You can either:

* Run `setup.sh` to set up the exercise in this directory.
    ```
    ./setup.sh
    ```
* Or, use your `exercise3` directory.

## Instructions

**NOTE:** This exercise refers to the default branch as `main`. If you are using an older Git client, you may see `master` instead of `main`.

1. Remove the merge commit we made at the end of exercise 3.
    ```
    git reset --hard HEAD^1
    ```

    If you run `git log`, you should see the latest commit is "Fix hello's echo command". The merge commit and the feature commit "Say goodbye to everyone" should have disappeared.

    Things are now exactly as they were just before we merged in the feature branch.
2. Switch to the feature branch.
    ```
    git checkout feature/say-goodbye-to-everyone
    ```
3. Run `git log` to see what our branch currently looks like.
    ```
    git log --graph --decorate --oneline --abbrev-commit --all
    ```

    The command above gives us a view of the main and feature branches. We can see that after the "Add application files" commit, the branches diverged - main had the bug fix commited, and the feature branch had the new feature committed.
4. Now, run `git rebase main` to rebase the feature branch onto the main branch. You can use `-Xtheirs` to resolve the merge conflicts automatically.
    ```
    git rebase -Xtheirs main
    ```
5. Now run `git log` again.
    ```
    git log --graph --decorate --oneline --abbrev-commit --all
    ```

    You should see that although we're still on our feature branch, we now have the latest commits from the main branch as well. The "Say goodbye to everyone" commit was replayed on top of the "Fix hello's echo command" commit.

    Everything now appears in a straight line. We can see that the main branch is still level with the bug fix, but it now appears as though our branch was based off of that bug fix, rather than the commit before it.
