# Contributing to CurateND

This document is intended for internal use only.

### Creating an Issue
[Issues for the repo](https://github.com/ndlib/sipity/issues) should have a clear functional scope and desired outcome.
This keeps issues actionable and cruft out of the backlog.

Issues do _not_ have to be stated in terms of a user story (Given…, When…, Then…; As a…, I want to…, So that…) as long as the desired outcome is clearly articulated.
Annotated screen shots are encouraged ([Skitch](https://evernote.com/skitch/) works pretty well).

Speculative feature requests should be [treated as a question](#what-if-i-have-a-question).

### Starting an Issue
```console
$ ./scripts/start-issue <the-issue-number>
```

See [./scripts/start-issue](https://github.com/ndlib/sipity/blob/master/scripts/start-issue) for further details.

### Closing an Issue
```console
$ ./scripts/close-issue <the-issue-number>
```

See [./scripts/close-issue](https://github.com/ndlib/sipity/blob/master/scripts/close-issue) for further details.

### Submitting a Pull Request
When submitting a pull request, make sure to submit a useful description of what you are doing.
If your pull request contains multiple commits, consider using `./script/build-multi-commit-message`.
It will generate rudimentary markdown from all of the commit messages.

### Commit Message

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

# What if I Have a Question?
* Open an issue and attach the “Question” label.
* [@mention](https://github.com/blog/821) someone on the team or, if you don’t know who is the right person to ask, send a notification to all of us using **@ndlib/dlt**.
* If an existing issue isn’t clear comment on it and add the “Needs Clarification” label.
