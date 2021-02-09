# Exercise 3 - Merge Conflicts

This exercise explores merging branches and handling merge conflicts.

In this exercise, we use a real `build.gradle` file so that we can create a somewhat realistic scenario. However, no knowledge of Gradle or `build.gradle` files is required, and Gradle itself isn't required for the exercise.

## Setup

1. Run `setup.sh` to set up the exercise.
    ```
    ./setup.sh
    ```
2. Configure Git to use the `diff3` conflict style. (optional)
    ```
    git config --global merge.conflictstyle diff3
    ```

## Instructions

**NOTE:** This exercise refers to the default branch as `main`. If you are using an older Git client, you may see `master` instead of `main`.

1. First, we'd like to implement a new feature in our application, so we'll switch to a new branch.
    ```
    git checkout -b feature/say-goodbye-to-everyone
    ```
2. Now, implement our new feature in `application.sh` by adding the `goodbye everyone` command to the bottom of the file.
    ```
    echo "goodbye everyone" >> application.sh
    ```
3. As we're implementing a new feature we'll also bump the minor version number, so open up `build.gradle` in a text editor and change `version = '1.5.7-SNAPSHOT'` to `version = '1.6.0-SNAPSHOT'`.
    ```diff
    -version = '1.5.7-SNAPSHOT'
    +version = '1.6.0-SNAPSHOT'
    ```

    You can also use the following command to make the change:
    ```
    sed -i '' -E -e "s/^version = .*$/version = '1.6.0-SNAPSHOT'/" build.gradle
    ```
4. Check your changes, then stage and commit them.
    ```
    git diff
    git add build.gradle application.sh
    git commit -m "Say goodbye to everyone"
    ```
5. Unfortunately, someone has just realised there's a bug in production and we need to fix it, so we'll forget about our branch for now. Switch back to the default branch.
    ```
    git checkout main
    ```
6. Modify `application.sh` so that the `hello` function uses `echo` instead of `wrong-echo`.
    ```diff
    -    wrong-echo "Hello $1!"
    +    echo "Hello $1!"
    ```

    You can also use the following command to make the change:
    ```
    sed -i 's/wrong-echo/echo/' application.sh
    ```
7. As we're making a bug fix we'll also bump the patch version number, so open up `build.gradle` in a text editor and change `version = '1.5.7-SNAPSHOT'` to `version = '1.5.8-SNAPSHOT'`.
    ```diff
    -version = '1.5.7-SNAPSHOT'
    +version = '1.5.8-SNAPSHOT'
    ```

    You can also use the following command to make the change:
    ```
    sed -i '' -E -e "s/^version = .*$/version = '1.5.8-SNAPSHOT'/" build.gradle
    ```
8. Check your changes, then stage and commit them.
    ```
    git diff
    git add build.gradle application.sh
    git commit -m "Fix hello's echo command"
    ```
9. Now that everything's working again, it's time to merge in our new feature!
    ```
    git merge feature/say-goodbye-to-everyone
    ```

    You should receive a merge conflict, and you'll see the following in your `build.gradle` file:
    ```
    <<<<<<< HEAD
    version = '1.5.8-SNAPSHOT'
    ||||||| f14a969
    version = '1.5.7-SNAPSHOT'
    =======
    version = '1.6.0-SNAPSHOT'
    >>>>>>> feature/say-goodbye-to-everyone
    ```

    At the top, we can see 'our' version of the line on the main branch, which we set to `1.5.8`. In the middle (assuming you set up `merge.conflictstyle diff3` at the beginning of the exercise) you'll see the original version of the line, which was `1.5.7`. At the bottom, you'll see 'their' version of the line (the version of the line we're merging in), which was `1.6.0`.
10. Edit `build.gradle` and set the version to `version = '1.6.0-SNAPSHOT'`. This will involve removing everything between the `<<<<<<<` and `>>>>>>>` marks, and replacing it with the final version of the line.

    Your file should look like the following:
    ```
    [...]
    group = 'com.example'
    version = '1.6.0-SNAPSHOT'

    task callScript(type: Exec) {
    [...]
    ```
11. With the conflict resolved, stage the file again and continue the merge commit.
    ```
    git add build.gradle
    git commit
    ```

## Exploring Further

### Resolving Merge Conflicts Automatically

You'll often see the two sides of a merge conflict referred to as "ours" and "theirs".

* `ours` - the current version of the changes
* `theirs` - the version you're merging in

There will be some occasions where you know that you want a specific side to take precedence. In this instance, you can use `git merge -Xours <branch>` or `git merge -Xtheirs <branch>` - you won't receive a merge conflict, and all conflicts will be resolved based on the preference you specified.

To find out more, see [Git Tools - Advanced Merging](https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging) from the Git Book.

### Resolving Conflicts More Easily

This workshop focuses on using Git on the command line, however many text editors and IDEs will either have support for handling merge conflicts built in, or you'll be able to download a Git plugin or extension to do it. You should find out how to resolve conflicts in your preferred IDE/text editor so that when you encounter a large number of conflicts, you have a tool on hand that can help you deal with them.

You can also use the `git mergetool` command to help resolve merge conflicts. However, this will typically land you in something like `vimdiff`, which you'll also need to know how to use.
