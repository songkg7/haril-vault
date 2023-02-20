---
title: "obsidian plugin 개발하기"
date: 2023-02-23 08:59:00 +0900
aliases: 
tags: [obsidian, plugin, side-project, typescript]
categories: 
---

# O2

github.com/songkg7/o2

> Obsidian to

## 문제인식

저는 현재 jekyll 블로그를 사용하여 포스팅을 하고 있기 때문에 [[Obsidian 사용 후기|Obsidian]] 의 markdown 문법과 블로깅을 위한 마크다운의 문법이 일부 호환되지 않습니다. 때문에 obsidian 에서 글을 작성하게 되면 블로그 발행을 위해 이후 jeykll 문법으로 수작업으로 수정해줘야하는 워크플로우가 있었습니다. 바꿔줘야하는 문법들은 다음과 같습니다.

- [[]] 을 사용한 post 간 링크는 obsidian 고유 문법
- img 파일의 경로 재지정
- jeykell 은 markdown 파일 이름을 post 의 url 로 사용하므로 obsidian 에서 사용하던 제목을 `yyyy-MM-dd-title.md` 의 형식으로 변환해야 한다
- callout 문법이 다르다

![[O2 - Page 3.png]]

layer 간의 이동이 발생하는 부분의 이중 점선 화살표는 수작업이 필요한 부분

obsidian 과 jekyll 을 병행해서 사용하는 이상 이 문법 변환 과정 및 attachment 복사 과정을 자동화해야할 필요가 있었습니다.

obsidian 은 Notion 과는 다르게 커뮤니티 플러그인을 통해 기능의 확장이 가능하니 한 번 직접 만들어보기로 합니다. 공식 문서를 좀 살펴보니 obsidian 은 plugin 을 NodeJS 기반으로 만들도록 가이드하고 있더군요. 언어의 선택지가 넓지 않은 것이 좀 아쉽지만 [[TypeScript]] 도 가볍게 찍먹해본 적은 있기에, 제대로 공부해볼겸 NodeJS/TS 환경을 구성했습니다.

## 설계 과정

Obsidian 문법을 다른 플랫폼의 문법으로 바꾼다는 의미로 Obsidian to, O2 라고 프로젝트 이름을 붙였습니다.

### 변환을 위한 준비

그럴듯한 이름도 지어놓았고, 그럼 이제 어떤 파일을 어떻게 변환해야 할까요?

저는 평소 `/ready` 라는 이름의 obsidian directory 아래에 초안을 보관해놓고 어느 정도 원고가 정리되면 jekyll 로 변환한 이후 블로그에 발행하는 작업을 하고 있었습니다. 작업이 완료되면 `/ready` 에서 `/published` directory 로 파일을 옮기구요.

이 방식을 그대로 프로그래밍하기로 했습니다. 다만 원본 파일이 수정되어버리면 obsidian 에서 문서를 읽을 때 문제가 생기기 때문에, 복사본을 만든 다음 복사본을 수정하여 jekyll 문법으로 변환하기로 했습니다.

이 단계까지를 가볍게 정리하자면 다음과 같습니다.

1. `/ready`의 `A.md` 는 `/published` 로 이동
2. 원본 파일(`/published/A.md`)의 복사본(`/ready/A.md`) 생성
3. `/ready/A.md` 의 제목 및 문법 변환
4. `/ready/yyyy-MM-dd-A.md` 를 jekyll 발행을 위한 경로로 이동

물론 아직 attachments 와 callout 문법 등의 처리는 되지 않았지만, 과정을 단순화시키기 위해 이 상태까지만 구현해봅시다.

#### copyToPublishedDirectory

```typescript
function getFilesInReady(plugin: O2Plugin): TFile[] {
    return this.app.vault.getMarkdownFiles()
        .filter((file: TFile) => file.path.startsWith(plugin.settings.readyDir))
}

async function copyToPublishedDirectory(plugin: O2Plugin) {
    const readyFiles = getFilesInReady.call(this, plugin)
    readyFiles.forEach((file: TFile) => {
        return this.app.vault.copy(file, file.path.replace(plugin.settings.readyDir, plugin.settings.publishedDir))
    })
}
```

`/ready` 폴더 안의 마크다운 파일들을 가져온 뒤 `file.path` 를 `publishedDir` 로 바꿔주면 간단하게 복사가 됩니다. 물론 실제로는 obsidian api 사용법을 잘 모르는 상태였기에 엄청난 삽질이 있었지만..

### Attachments 재설정

```typescript
function convertResourceLink(plugin: O2Plugin, title: string, contents: string) {
    const absolutePath = this.app.vault.adapter.getBasePath()
    const resourcePath = `${plugin.settings.jekyllResourcePath}/${title}`
    fs.mkdirSync(resourcePath, { recursive: true })

    const relativeResourcePath = plugin.settings.jekyllRelativeResourcePath

    // 변경하기 전 resourceDir/image.png 를 assets/img/<title>/image.png 로 복사
    extractImageName(contents)?.forEach((resourceName) => {
        fs.copyFile(
            `${absolutePath}/${plugin.settings.resourceDir}/${resourceName}`,
            `${resourcePath}/${resourceName}`,
            (err) => {
                if (err) {
                    new Notice(err.message)
                }
            }
        )
    })
    return contents.replace(ObsidianRegex.IMAGE_LINK, `![image](/${relativeResourcePath}/${title}/$1)`)
} 
```

attachments 는 vault 의 영역 외로 파일의 이동이 필요하므로 obsidian 이 기본 제공하는 api 만으로는 구현할 수 없습니다. 때문에 `fs` 를 사용해서 파일시스템에 직접 접근합니다.
 
공식문서 참조 링크 추가

> [!TIP] Desktop only
> 파일시스템에 직접 접근한다는 것은 모바일에서의 사용이 어려워진다는 의미이므로, Obsidian 공식 문서에서는 이 경우 desktop only flag 를 표시하도록 가이드하고 있습니다.

### Callout 문법 변환

```typescript
export namespace ObsidianRegex {
    export const IMAGE_LINK = /!\[\[(.*?)]]/g
    export const DOCUMENT_LINK = /(?<!!)\[\[(.*?)]]/g
    export const CALLOUT = /> \[!(NOTE|WARNING|ERROR|TIP|INFO|DANGER)] .*?\n(>.*)/ig
}
```

**Jekyll chirpy**

```
> callout title
{: .promt-info}
```

지원 키워드 : tip, info, warning, danger

**Obsidian**

```
> [!NOTE] callout title
> contents
```

지원 키워드 : tip, info, note, warning, danger, error

보시는 바와 같이 둘의 문법은 다소 상이하기 때문에 이 부분을 치환하기 위해서 정규표현식을 사용하고 replacer 를 구현해줘야 합니다.

```typescript
export function convertCalloutSyntaxToChirpy(content: string) {
    function replacer(match: string, p1: string, p2: string) {
        if (p1.toLowerCase() === 'note') {
            p1 = 'info'
        }
        if (p1.toLowerCase() === 'error') {
            p1 = 'danger'
        }
        return `${p2}\n{: .prompt-${p1.toLowerCase()}}`
    }

    return content.replace(ObsidianRegex.CALLOUT, replacer)
}
```

### 변환이 완료된 파일의 이동

현재 사용하고 있는 jekyll 기반 블로그들은 발행을 위해 post 들이 위치해야하는 경로가 정해져있습니다. 다만 클라이언트마다 블로그 프로젝트가 위치한 경로가 다를 것이기 때문에 custom 한 path 처리를 위해 parameter 로 알아내야할 필요가 있었습니다. 이 부분은 설정 탭을 구성해서 받아오기로 하고 아래와 같은 입력 폼을 만들었습니다.

![[path-settings.png]]

```typescript
async function moveFilesToChirpy(plugin: O2Plugin) {
    const absolutePath = this.app.vault.adapter.getBasePath()
    const sourceFolderPath = `${absolutePath}/${plugin.settings.readyDir}`
    const targetFolderPath = plugin.settings.jekyllTargetPath

    fs.readdir(sourceFolderPath, (err, files) => {
        if (err) throw err

        files.forEach((filename) => {
            const sourceFilePath = path.join(sourceFolderPath, filename)
            const targetFilePath = path.join(targetFolderPath, filename)

            fs.rename(sourceFilePath, targetFilePath, (err) => {
                if (err) {
                    new Notice(err.message)
                    throw err
                }
            })
        })
    })
}

```

이렇게 모든 변환이 완료된 파일을 jekyll 의 `_post` 경로로 이동시켜주면 변환작업이 완료됩니다.

## 결과

Kotlin 이나 Java 만 사용하다가 TypeScript 를 사용하려니 익숙하지 않고, 지금 쓰고 있는 코드가 Best practice 가 맞는지 고민이 많이 됐지만 나름 신선한 경험이였습니다. 덕분에 `anync-await` 에 대해서도 공부하게 되었고, 또 다른 기술 스택이 하나 생긴 것 같아서 뿌듯하네요.

플러그인을 만들던 시기는 일본여행 도중이였기 때문에 많은 시간을 투자하진 못했습니다.

비행기 이동 중에 코딩하던 사진 추가

이 글을 포스팅할 때 직접 만든 플러그인을 사용해보자.

### community plugin 에 배포하기 위한 PR 작성

![[obsidian-releases-pr.png]]

## Next step

- 변환 과정에서 에러 발생시 롤백을 위한 트랜잭션 구현
- 한글 및 특수문자가 제목이나 attachment 에 포함되어 있을 경우 
	- markdown metadata 의 title 이 보이는 제목이 되고 문서의 제목은 url 로 사용되기 때문에 가급적 영어로 사용하는 것이 권장

## Reference

- [Obsidian plugins](https://marcus.se.net/obsidian-plugin-docs/getting-started/create-your-first-plugin)
