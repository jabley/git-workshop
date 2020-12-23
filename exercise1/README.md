# Exercise 1 - Raw Git Files

This exercise explores how Git stores your commits, file trees, and files.

## Setup

1. Run `setup.sh` to set up the exercise.
    ```
    ./setup.sh
    ```

## Instructions

1. First, take a look at what the setup script has created.
    ```
    git log --patch
    ```
    * `git log` will show you the commits that were created, including their hashes.
    * `--patch` will show you what those commits actually did (i.e. what files they changed).
    <details>
    <summary>Example (expand)</summary>

    ```
    $ git log -p
    commit 905545f338c8cd193c29230057dc3f7aa682373b (HEAD -> master)
    Author: Neil Farrington <me@neilfarrington.com>
    Date:   Tue Dec 22 11:02:16 2020 +0000

        Commit 2

    diff --git a/file2 b/file2
    new file mode 100644
    index 0000000..705e376
    --- /dev/null
    +++ b/file2
    @@ -0,0 +1 @@
    +Test file 2

    commit e4a563d31ef05a6cb81bcbab802b45962af6d129
    Author: Neil Farrington <me@neilfarrington.com>
    Date:   Tue Dec 22 11:02:16 2020 +0000

        Commit 1

    diff --git a/file1 b/file1
    new file mode 100644
    index 0000000..870c88c
    --- /dev/null
    +++ b/file1
    @@ -0,0 +1 @@
    +Test file 1

    commit 3c2aff9994145baf3fd3c375115c938a24595133
    Author: Neil Farrington <me@neilfarrington.com>
    Date:   Tue Dec 22 11:02:16 2020 +0000

        Add .gitignore

    diff --git a/.gitignore b/.gitignore
    new file mode 100644
    index 0000000..623bf7e
    --- /dev/null
    +++ b/.gitignore
    @@ -0,0 +1,2 @@
    +/README.md
    +/setup.sh
    ```

    </details>
2. View the raw contents of the latest commit with `git cat-file`, using the commit hash in your output. In the example output above, it's `905545f338c8cd193c29230057dc3f7aa682373b` (it will be different for you, though).
    ```
    git cat-file -p <commit_hash>
    ```

    <details>
    <summary>Example (expand)</summary>

    ```
    $ git cat-file -p 905545f338c8cd193c29230057dc3f7aa682373b
    tree c2be26538c3cb2c104fbcdd136d18097cfa29b45
    parent e4a563d31ef05a6cb81bcbab802b45962af6d129
    author Neil Farrington <me@neilfarrington.com> 1608634936 +0000
    committer Neil Farrington <me@neilfarrington.com> 1608634936 +0000

    Commit 2
    ```

    </details>
    <br>
    Here, `cat-file` has shown us how Git has stored the commit. You'll notice it looks somewhat similar to the output of `git log`.
3. View the raw contents of the file tree, using the `tree` hash displayed in the previous command.
    ```
    git cat-file -p <tree_hash>
    ```
    <details>
    <summary>Example (expand)</summary>

    ```
    $ git cat-file -p c2be26538c3cb2c104fbcdd136d18097cfa29b45
    100644 blob 623bf7e410f60d6e22a75c297a1a19dc2023b72f	.gitignore
    100644 blob 870c88cbea8be3e10611dd386ddb2273a1a69675	file1
    100644 blob 705e37612d07d8209d12eb0a5ace2fce7f146c76	file2
    ```

    </details>
4. View the raw contents of one of the blobs, for example the `file1` blob.
    ```
    git cat-file -p <blob_hash>
    ```
    <details>
    <summary>Example (expand)</summary>

    ```
    $ git cat-file -p 870c88cbea8be3e10611dd386ddb2273a1a69675
    Test file 1
    ```

    </details>
    <br>
    We can see here that the blob is just the contents of the file.

## Exploring Further

### Viewing the raw files

Using `git cat-file` shows us how Git is storing our commits, trees, blobs and everything else, however it doesn't show _exactly_ what the files look like in their raw form.

Git compresses its underlying files, so to read them, we need to decompress them.

In the following example, we read the raw blob file using the blob hash from the previous section (`870c88cbea8be3e10611dd386ddb2273a1a69675`). The example uses Docker, to help avoid inconsistencies between environments (e.g. Python version).

```
$ docker run --rm -i python:3.9-alpine python -c 'import sys,zlib;sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))' < .git/objects/87/0c88cbea8be3e10611dd386ddb2273a1a69675
blob 12Test file 1
```

We can see that the start of the file is `blob`, so that Git can identify the type of file. The `12` is the size of the contents, and the rest is the actual contents of the blob. Although you can't see it, there is all a `null` character between the size and contents, i.e. `blob 12<null>Test file 1`, to help structure the file.

For more information, check out <https://matthew-brett.github.io/curious-git/reading_git_objects.html>.

### Adding directories

The main part of the exercise shows you what tree objects look like for files, but not directories.

In the example below, we can see that tree objects branch out for directories, forming a tree structure.

```
$ mkdir dir1/
$ echo "A file in dir1" > dir1/a-file-in-a-directory
$ git add dir1/a-file-in-a-directory
$ git commit -m "Add a file in a directory"
$ git log
commit 371cf35e1ddd0b6c4206663cdae75debe2ddd441 (HEAD -> master)
Author: Neil Farrington <me@neilfarrington.com>
Date:   Tue Dec 22 14:49:53 2020 +0000

    Add a file in a directory
[...]

$ git cat-file -p 371cf35e1ddd0b6c4206663cdae75debe2ddd441
tree 8437c8e29235275c39a36b79151345b168a47bb8
parent 905545f338c8cd193c29230057dc3f7aa682373b
author Neil Farrington <me@neilfarrington.com> 1608648593 +0000
committer Neil Farrington <me@neilfarrington.com> 1608648593 +0000

Add a file in a directory

$ git cat-file -p 8437c8e29235275c39a36b79151345b168a47bb8
100644 blob 623bf7e410f60d6e22a75c297a1a19dc2023b72f	.gitignore
040000 tree ebce670cb888d5906058a5415677902dffd62dec	dir1
100644 blob 870c88cbea8be3e10611dd386ddb2273a1a69675	file1
100644 blob 705e37612d07d8209d12eb0a5ace2fce7f146c76	file2

$ git cat-file -p ebce670cb888d5906058a5415677902dffd62dec
100644 blob 1e2c56bd1cd257174f3ccf293d1b7ae0cf678047	a-file-in-a-directory
```

So, our simple tree looks like this:

```
tree <root>
├── tree <dir1>
│   └── blob <a-file-in-a-directory>
├── blob <file1>
└── blob <file2>
```
