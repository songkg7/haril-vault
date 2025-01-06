---
title: key generation error
date: 2022-09-11T11:36:00
aliases: 
tags:
  - gpg
  - keybase
  - security
categories: 
updated: 2025-01-07T00:36
---

```console
key generation error: Unknown signature subpacket: 34
```

[[Keybase]] 에 gpg key 를 등록하려던 중 위와 같은 에러가 발생했다.  해결을 위해 방법을 찾다보니 github 에 다음과 같은 해결법이 등록되어 있었다.

```bash
$ gpg --edit-key mykey

gpg> showpref
[ultimate] (1). mykey
     Cipher: AES256, AES192, AES, 3DES
     AEAD: OCB, EAX
     Digest: SHA512, SHA384, SHA256, SHA224, SHA1
     Compression: ZLIB, BZIP2, ZIP, Uncompressed
     Features: MDC, AEAD, Keyserver no-modify

gpg> setpref AES256 AES192 AES 3DES SHA512 SHA384 SHA256 SHA224 SHA1 ZLIB BZIP2 ZIP
Set preference list to:
     Cipher: AES256, AES192, AES, 3DES
     AEAD: 
     Digest: SHA512, SHA384, SHA256, SHA224, SHA1
     Compression: ZLIB, BZIP2, ZIP, Uncompressed
     Features: MDC, Keyserver no-modify
Really update the preferences? (y/N) y

gpg> save
```

이후 정상 실행된다. 자세한 사항은 링크를 참조.

## Reference

- [github issue](https://github.com/keybase/keybase-issues/issues/4025)