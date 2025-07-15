---
title: Spotless
date: 2025-06-22T21:05:12+09:00
aliases: 
tags:
  - formatter
description: 
updated: 2025-07-10T12:48
---

## Contents

```groovy
plugins {
    id 'com.diffplug.spotless' version "7.0.4"
}

spotless {
    java {
        importOrder()
        removeUnusedImports()
        trimTrailingWhitespace()
        cleanthat()
        palantirJavaFormat()
        formatAnnotations()
        endWithNewline()
    }

    kotlin {
        ktlint()
        suppressLintsFor {
            step = 'ktlint'
            shortCode = 'standard:no-wildcard-imports'
        }
        endWithNewline()
    }

    kotlinGradle {
        ktlint()
    }

    json {
        target 'src/**/*.json'
        simple()
    }

    yaml {
        target 'src/**/*.yaml'
        jackson()
        prettier()
    }
}
```

- `./gradlew spotlessCheck` and `./gradlew spotlessApply`
- 코드 스타일을 지키지 않을 경우 빌드가 실패하도록 할 수 있음
- palantir format plugin 을 [[IntelliJ]] 에 설치하면 훨씬 효과적
- `.editorconfig` 파일을 우선적으로 적용하도록 설정하는 것도 가능
- ktlint 적용이 매우 쉬움
    - 최근 intellij 가 케어하지 못하고 있는 trailing comma 규칙도 잘 적용됨

### pre-commit hook

```bash
#!/bin/bash
echo "Running Spotless style check..."

./gradlew spotlessCheck

if [ $? -ne 0 ]; then
    echo "ERROR: Spotless check failed. Run './gradlew spotlessApply' to fix and try committing again."
    exit 1
fi

echo "Spotless check passed."
exit 0
```

staged 상태의 커밋에만 apply 를 적용할 수 있다면 완전한 자동화가 가능하다. 다만 npm package 에 대한 의존성이 필요하다는 단점이 있다.

```bash
npx husky-init && npm install
npm install --save-dev lint-staged
```

```json
// package.json
{
  // ...
  "lint-staged": {
    "*.{java,kt,kts}": "./gradlew spotlessApply"
  }
}
```

## Reference

- [spotless/plugin-gradle/README.md at main · diffplug/spotless · GitHub](https://github.com/diffplug/spotless/blob/main/plugin-gradle/README.md)

## Next step

stage 상태인 파일에만 spotless 적용하기

```bash
#!/bin/bash

BLUE=$'\e[1;34m'
RESET=$'\e[0m'

printf "%s> Running Spotless style check...%s\n\n" "$BLUE" "$RESET"

# Create a patch file
GIT_STASH_FILE="stash.patch"

# Stash unstaged changes
git diff > "$GIT_STASH_FILE"

# add the patch so it is not stashed
git add "$GIT_STASH_FILE"

# stash untracked files
git stash -k

# apply spotless
./gradlew spotlessApply --daemon

# re-add any changes that spotless created
git add -u

# store the last exit code
RESULT=$?

if test -f "$GIT_STASH_FILE";
then
  printf "%s has been found\n" "$GIT_STASH_FILE"

    # apply the patch
    git apply stash.patch --allow-empty

    # delete the patch and re-add that to the index
    rm -f stash.patch
    git add stash.patch
else
    printf "%s has not been found\n" "$GIT_STASH_FILE"
fi

# delete the WIP stash
git stash drop

# return the exit code
exit $RESULT
```
 