---
title: commitizen
date: 2024-10-30T13:58:00
aliases: 
tags:
  - git
description: 
updated: 2025-02-27T17:20
---

## Custom

```yaml
---
commitizen:
  customize:
    bump_map:
      break: MAJOR
      fix: PATCH
      hotfix: PATCH
      new: MINOR
    bump_pattern: ^(break|new|fix|hotfix)
    change_type_map:
      feat: Feature
      fix: Bug Fix
    change_type_order:
    - BREAKING CHANGE
    - feat
    - fix
    - refactor
    - perf
    changelog_pattern: ^(feat|fix)?(!)?
    commit_parser: ^(?P<change_type>feat|fix):\s(?P<message>.*)?
    example: 'feat: [LBSC-001] this feature enable customize through config file'
    info: This is customized info
    info_path: cz_customize_info.txt
    message_template: '{{change_type}}: [LBSC-{{ticket}}] {% if show_message %}{{message}}{%
      endif %}'
    questions:
    - choices:
      - name: 'feat: A new feature.'
        value: feat
      - name: 'fix: A bug fix.'
        value: fix
      - name: 'refactor: A code change that neither fixes a bug nor adds a feature.'
        value: refactor
      - name: 'perf: A code change that improves performance.'
        value: perf
      - name: 'test: Adding missing tests or correcting existing tests.'
        value: test
      - name: 'docs: Documentation only changes.'
        value: docs
      - name: 'style: Changes that do not affect the meaning of the code (white-space,
          formatting, missing semi-colons, etc).'
        value: style
      - name: 'chore: Changes to the build process or auxiliary tools and libraries
          such as documentation generation.'
        value: chore
      message: Select the type of change you are committing
      name: change_type
      type: list
    - message: Jira ticket number (ex. 182).
      name: ticket
      type: input
    - message: Body.
      name: message
      type: input
    - message: Do you want to add body message in commit?
      name: show_message
      type: confirm
    schema: '<type>: [<ticket-number>] <body>'
    schema_pattern: (feat|fix):(\s.*)
  name: cz_customize
  tag_format: v$major.$minor.$patch$prerelease
  version: 1.0.6
```

### Jira integration

[GitHub - apheris/cz-github-jira-conventional: Extend the commitizen tools to create conventional commits and CHANGELOG that link to Jira and GitHub.](https://github.com/apheris/cz-github-jira-conventional)