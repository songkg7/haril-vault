---
title: "블로그 검색 노출을 위한 이미지 최적화하기"
date: 2023-04-18 15:15:00 +0900
aliases: 
tags: [webp, imagemin, obsidian, jekyll, seo]
categories: 
---

블로그 포스팅 최적화를 위한 자동화 과정 중 이미지 최적화에 대해 이야기합니다.

## 문제 인식

SEO 최적화를 위해서는 포스팅에 포함되는 이미지는 최대한 작을수록 좋다. 검색 엔진의 크롤링봇들의 효율이 올라가고 페이지 로딩이 빨라져서 사용자 경험에도 긍정적인 영향을 준다.

그렇다면 어떤 이미지 포맷을 사용해야할까?

구글에서는 이 문제를 해결하기 위해 Webp 라는 이미지 포맷을 직접 개발했고, 사용을 적극 권장하고 있다. 광고로 먹고 사는 구글에게 있어서도 이미지 최적화는 사용자가 빠르게 웹사이트 광고에 도달하게 해주기 때문에 수익성에 직접적으로 연관되어 있다.

실제로 2.8MB 정도의 jpg 파일을 webp 로 변환한 결과, 49kb 수준으로 감소했다. 품질 손실이 일부 발생하지만 웹페이지에서는 체감하기 힘든 수준이다.

%%space opera theater 변환 전후 캡쳐 추가%%

## 해결 방법 접근

이미지 프로세싱 관련 라이브러리로는 sharp 가 가장 유명한 라이브러리이지만, OS 의존적이여서 [[Obsidian]] 플러그인으로는 사용할 수가 없다. 혹여나 잘못 알고 있는 것이 아닐까 하여 [관련 커뮤니티]()에서 해당 부분을 질문하고 사용할 수 없다는 명확한 답변을 받았다.

![[Pasted image 20230418152006.png]]

![[Pasted image 20230418152135.png]]

![[Pasted image 20230418152325.png]]

관련 커뮤니티 대화 기록

imagemin 을 선택해서 사용하기로 한다.

imagemin 은 node 환경에서 최적화되어 있고, obsidian plugin 은 platform 이 browser 여야 동작했다.

![[Pasted image 20230418173447.png]]

결국 다른 방법이 필요하다.

### npm script

플러그인에 기능을 추가하는 것이 아니라 jekyll 프로젝트 내부에 직접 스크립팅을 하면 간단하게 포맷 컨버팅을 할 수 있다.

```javascript
import imagemin from 'imagemin';
import imageminWebp from 'imagemin-webp';
import fs from 'fs';
import path from 'path';

async function deleteFilesInDirectory(dir) {
  const files = fs.readdirSync(dir);

  files.forEach(function (file) {
    const filePath = path.join(dir, file);
    const extname = path.extname(filePath);
    if (extname === '.png' || extname === '.jpg' || extname === '.jpeg') {
      fs.unlinkSync(filePath);
      console.log(`remove ${filePath}`);
    }
  });
}

async function convertImages(dir) {
  const subDirs = fs
    .readdirSync(dir)
    .filter((file) => fs.statSync(path.join(dir, file)).isDirectory());

  await imagemin([`${dir}/*.{png,jpg,jpeg}`], {
    destination: dir,
    plugins: [imageminWebp({ quality: 75 })]
  });
  await deleteFilesInDirectory(dir);

  for (const subDir of subDirs) {
    const subDirPath = path.join(dir, subDir);
    await convertImages(subDirPath);
  }
}

(async () => {
  await convertImages('assets/img');
})();
```

이 방법은 빠르게 이미지 최적화를 할 수는 있지만, O2 에 의한 문법 변환 과정 외부에 존재하기 때문에 포맷을 변경한 후 사용자는 직접 해당 이미지를 다시 마크다운 문서에 링크해줘야 하는 작업이 추가된다.

블로그 포스팅의 모든 프로세스를 자동화하고자 [[develop obsidian plugin|O2]] 를 개발했는데 O2 로 통제할 수 없는 외부 프로세스를 생성하는 것은 내키지 않았다.

`.png)$` 정규표현식을 사용해서 이미지 경로를 `webp` 로 변경해버리는 것도 괜찮겠다.

## Reference

- Sharp
- Imagemin
- Obsidian Community
