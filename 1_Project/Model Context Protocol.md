---
title: Model Context Protocol
date: 2025-03-15T20:43:37+09:00
aliases:
  - MCP
tags:
  - ai
description: 
updated: 2025-04-07T13:22
---

## What is MCP?

- 24년 11월 19일 소개
- LLM 과 외부 도구의 연결 인터페이스
- 초반에는 놀랍게도 아무도 관심을 주지 않음
    - [MCP - Explore - Google Trends](https://trends.google.com/trends/explore?date=today%203-m&q=MCP&hl=en)
    - MCP 의 핵심은 외부 도구를 LLM 에 연동하는 것인데, 사용할 수 있는 호스트가 없었기 때문
- 25년 2월 중순 Cursor AI 에서 MCP 지원 업데이트 이후 MCP 가 주목받기 시작
    - USB-C 타입의 메이저 지원이라고 비유됨
    - 기존 대화형 웹에 비해 Cursor 는 에디터라는 점이 달랐고, MCP 로 얻은 정보를 바탕으로 즉시 파일 편집이 가능했음
- MCP 생태계의 가능성을 사람들이 목도하고 매우 빠르게 확산되면서 OpenAI 도 MCP 공식 지원 발표
- LangChain 도 MCP 처럼 다양한 도구를 지원하지만, 각기 다른 모양으로 지원했다
    - 개발자들이 직접 기여해야 했음
    - [LangChain 연동](https://guide.ncloud-docs.com/docs/clovastudio-dev-langchain)
    - MCP 라는 표준이 등장하면서 새로운 도구 지원의 부담에서 한시름 덜 것으로 예상
    - 물론 아직은 초기인만큼 치명적인 문제점이 있음 (마지막에 설명).
- 현시점 [Smithery](https://smithery.ai/) 가 가장 인기가 많은 것으로 보임

## MCP Host

Claude Desktop, Cursor AI 등

1. MCP 클라이언트와 LLM 클라이언트를 모두 관리
2. MCP에서 도구 목록을 가져와 LLM에 전달
3. LLM의 도구 호출 요청을 감지하고 MCP로 전달
4. 도구 호출 결과를 다시 LLM에 전달
5. 최종 응답을 사용자에게 제공

## MCP Client

- MCP Server 와 Host 를 사이에서 중계
- Cursor AI 의 경우는 Client 기능까지 포함하고 있음

## MCP Server

- [[uv]] 사용
    - ~~Cursor 에서 uv 로 MCP server 를 실행시키기는 어려웠다. [[Docker]] 컨테이너를 빌드하는게 좋을듯~~
    - 아마 uv 의 동작 방식 때문에 그런듯하다. uv 는 venv 에 있는 mcp 를 실행시키는 것으로 아는데 확인이 필요하다.
        - `uv --directory` 옵션을 사용하여 문제 해결
    - `pip install "mcp[cli]` 로 global 에 mcp 를 설치할 경우는 Cursor 에서도 mcp 를 당연하지만 잘 실행시킨다.

```python
import httpx
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("My App")


@mcp.tool()
def calculate_bmi(weight_kg: float, height_m: float) -> float:
    """Calculate BMI given weight in kg and height in meters"""
    return weight_kg / (height_m**2)


@mcp.tool()
async def fetch_weather(city: str) -> str:
    """Fetch current weather for a city"""
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.weather.com/{city}")
        return response.text
```

![](https://i.imgur.com/rIkDpfu.png)

키를 cm 로 입력했는데 m 단위로 변환 후 mcp 를 호출하는 것을 볼 수 있다.

```json
{
  "mcpServers": {
    "bmi-calculator": {
      "command": "uv",
      "args": [
        "--directory",
        "/Users/haril/projects/mcp-demo",
        "run",
        "mcp",
        "run",
        "main.py"
      ]
    }
  }
}
```

## Idea

-

## Conclusion

- 기존 대화형 클라이언트의 한계를 외부 API 호출로 극복하게 되면서 가능성이 무한대로 확장가능해졌다
- 비슷한 MCP Server 를 여러개 추가하게 되면 host 에서 어떤 server 에 요청해서 정보를 가져와야할지 어려워하는 모습을 보인다
    - Cursor AI 의 경우 40개가 넘어가면 경고와 함께 더 이상 MCP 추가가 불가능
    - Map MCP server 를 Naver, Kakao, Tmap 을 추가해뒀다고 하면, POI 정보를 요청할 시 해당 POI 를 갖지 않은 CP 에 요청이 날아갈 수 있다
    - Prompt 에서 미리 지정해주면 되지만, 유저가 항상 어느 정보가 어디에 있는지 알고 있어야 한다는 문제가 있다
        - = 사람이 컨텍스트를 미리 알고 질문을 해야 한다?
- 사실상 tool 말고는 쓸게 없다
    - Resources, Prompt, roots 등 이 정의되어 있지만 실행을 위해서는 명시적인 조건이 필요하다.
    - 프롬프트 잘 써서 호출해야한다는 의미
    - 그렇다면 호출하는 주체가 사람이지 않나? 이걸 AI agent 의 기능이라고 할 수 있을까?
- 보안 문제가 매우 심각하다
    - 데이터를 외부(MCP Server)로 전송한다
    - 공식 MCP Server 가 아니라면 그 데이터를 어떻게 관리할 지 우려된다
    - Docker 를 사용하여 Local 에 MCP Server 를 띄우거나 폐쇄된 환경에서 MCP Server 를 관리할 것이 권장된다
- 현재까지 알려진 보안 취약점
    - 자격 증명 및 토큰 탈취 (MCP server 를 위한 토큰을 로컬에 저장하는 점)
    - 중앙 집중식 아키텍처의 보안 위험
    - 프롬프트 삽입 공격
    - 과도한 권한 요청 및 필요 이상의 데이터 접근
    - 공급망 오염 (npm 등의 패키지에 mcp 에 의한 오염된 코드 배포 사례)
    - 데이터베이스 수정 등에 대한 승인 워크플로우 부재

## Reference

- [Introduction - Model Context Protocol](https://modelcontextprotocol.io/introduction)
- [GitHub - modelcontextprotocol/python-sdk: The official Python SDK for Model Context Protocol servers and clients](https://github.com/modelcontextprotocol/python-sdk)
- [MCP의 모든 것을 알아봅시다.](https://velog.io/@k-svelte-master/what-is-mcp)
- [LinkedIn](https://www.linkedin.com/posts/rascal-hyunjun_mcpmodel-context-protocol-%EC%97%90-%EB%8C%80%ED%95%B4%EC%84%9C%EB%8A%94-%EB%A7%90%EC%9D%84-%EC%A2%80-%EC%95%84%EB%81%BC%EB%A0%A4%EA%B3%A0-activity-7314610516029501440-iC0V?utm_source=share&utm_medium=member_ios&rcm=ACoAADVs1_sBqre1AV6fJXkU4LAid0kfi4M76i0)
