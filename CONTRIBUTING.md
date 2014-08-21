# Contributing to CurateND

This document is intended for internal use only.

## Commit Message

A well-formed commit message should:

* Have a meaningful title (50 characters or less)
* If applicable have
  * A reference to JIRA or Github issues
  * A more detailed description

If you are merging a pull request, make sure it has the necessary components.
If a reference to JIRA or Github is missing, ask the committer if there should be one.

### Example

```console
Present tense short summary (50 characters or less)

More detailed description, if necessary. It should be wrapped to 72
characters. Try to be as descriptive as you can, even if you think that
the commit content is obvious, it may not be obvious to others. You
should add such description also if it's already present in bug tracker,
it should not be necessary to visit a webpage to check the history.

Description can have multiple paragraphs and you can use code examples
inside, just indent it with 4 spaces:

    class PostsController
      def index
        respond_with Post.limit(10)
      end
    end

You can also add bullet points:

- you can use dashes or asterisks

- also, try to indent next line of a point for readability, if it's too
  long to fit in 72 characters

Add tags for JIRA and/or Github

DLTP-109 #close
Closes #5
```