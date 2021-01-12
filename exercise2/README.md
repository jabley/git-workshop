# Exercise 2 - Exploring '.git' a Little Further

This exercise explores the `.git` directory a little further.

## Setup

1. Run `setup.sh` to set up the exercise.
    ```
    ./setup.sh
    ```

## Instructions

**NOTE:** This exercise refers to the default branch as `main`. If you are using an older Git client, you may see `master` instead of `main`.

1. First, let's take a look at the `HEAD` file:
    ```
    cat .git/HEAD
    ```
    <details>
    <summary>Example (expand)</summary>

    ```
    $ cat .git/HEAD
    ref: refs/heads/main
    ```

    </details>

    You'll see that the special reference `HEAD` currently points to the head of your default branch. The path given matches the path on disk in the next step.
2. All of our heads are stored in `.git/refs/heads/`:
    ```
    ls .git/refs/heads/
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ ls .git/refs/heads/
    main
    ```

    </details>

    The only head we have at the moment is for our default branch.
3. Let's take a look at what's inside the head file:
    ```
    cat .git/refs/heads/main
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ cat .git/refs/heads/main
    1ad6bfbb2da958111d3db64c868cf3d297de6f2b
    ```

    </details>

    The only thing inside the file should be a reference to the commit the head is pointing at.

    In the example, the head for the `main` branch is pointing to the `1ad6bfbb2da958111d3db64c868cf3d297de6f2b` commit.
4. If we run `git log`, we'll see that the reference the head is pointing to is the same as the commit hash for our latest commit.
    ```
    git log
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ git log
    commit 1ad6bfbb2da958111d3db64c868cf3d297de6f2b (HEAD -> main)
    Author: Neil Farrington <neil.farrington@moo.com>
    Date:   Wed Dec 23 15:50:57 2020 +0000

        Add file2
    [...]
    ```

    </details>

5. The previous steps to view and follow HEAD to a specific commit can be accomplished in a single Git command:
    ```
    git rev-parse HEAD
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ git rev-parse HEAD
    1ad6bfbb2da958111d3db64c868cf3d297de6f2b
    ```

    </details>
6. Now, checkout the previous commit using `git rev-parse HEAD~1` and `git checkout`.
    ```
    git rev-parse HEAD~1
    git checkout <hash>

    # or, combining the two commands
    git checkout $(git rev-parse HEAD~1)
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ git rev-parse HEAD~1
    9de806687387edb072fda6b0603daa6a8c147944
    ```

    ```
    $ git checkout 9de806687387edb072fda6b0603daa6a8c147944
    Note: switching to '9de806687387edb072fda6b0603daa6a8c147944'.

    You are in 'detached HEAD' state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by switching back to a branch.

    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -c with the switch command. Example:

      git switch -c <new-branch-name>

    Or undo this operation with:

      git switch -

    HEAD is now at 9de8066 Add file1
    ```

    </details>

    Our working tree is now as it was in the previous commit, and if you run `ls` you'll see that `file2` has disappeared, since that was added in the latest commit.

7. Now that we are in detached head mode, let's check `git status`.

    ```
    git status
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ git status
    HEAD detached at 9de8066
    nothing to commit, working tree clean
    ```

    </details>

    Git helpfully tells us that our current HEAD is detached at the commit we checked out.

8. Finally, we'll check the HEAD file again.

    ```
    cat .git/HEAD
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ cat .git/HEAD
    9de806687387edb072fda6b0603daa6a8c147944
    ```

    </details>

    Notice that it no longer refers to the head of a specific branch. Instead, it points directly to the commit itself.

## Exploring Further

### Committing in Detached Head Mode

You can also experiment with committing in detached head mode:

```
echo "Test file 3" > file3
git add file3
git commit -m "Add file3"
git status
cat .git/HEAD
```

Notice that `git status` now says `HEAD detached from <hash>` instead of `HEAD detached at <hash>`. `HEAD` itself now refers to the commit we just made.

### Real Projects

The example we worked through in the exercise is very simple.

To take things further, clone a remote repository (if you're stuck for ideas, you could pick one from <https://github.com/explore>) and explore its file structure.

For example, you might note that a new `remotes` directory exists in `.git/refs/` has been created, and explore that.
