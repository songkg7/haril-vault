---
title: Model Context Protocol
date: 2025-03-15T20:43:37+09:00
aliases:
  - MCP
tags:
  - ai
description: 
updated: 2025-04-06T21:53
---

## What is MCP?

- 24년 11월 19일 소개
- 초반에는 놀랍게도 아무도 관심을 주지 않음
    - MCP 의 핵심은 외부 도구를 LLM 에 연동하는 것인데, 사용할 수 있는 호스트가 없었기 때문
- 25년 2월 중순 Cursor AI 에서 MCP 지원 업데이트 이후 MCP 가 주목받기 시작
    - USB-C 타입의 메이저 지원이라고 비유됨
    - 기존 대화형 웹에 비해 Cursor 는 에디터라는 점이 달랐고, MCP 로 얻은 정보를 바탕으로 즉시 파일 편집이 가능했음
- MCP 생태계의 가능성을 사람들이 목도하고 매우 빠르게 확산되면서 OpenAI 도 MCP 공식 지원 발표
- LangChain 도 MCP 처럼 다양한 도구를 지원하지만, 각기 다른 모양으로 지원했다
    - 개발자들이 직접 기여해야 했음
    - MCP 라는 표준이 등장하면서 새로운 도구 지원의 부담에서 한시름 덜 것으로 예상
- 현시점 [Smithery - Model Context Protocol Registry](https://smithery.ai/) 가 가장 인기가 많은 것으로 보임

## MCP Host

## MCP Client

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

## Conclusion

- 기존 대화형 클라이언트의 한계를 외부 API 호출로 극복하게 되면서 가능성이 무한대로 확장가능해졌다
- 비슷한 MCP Server 를 여러개 추가하게 되면 host 에서 어떤 server 에 요청해서 정보를 가져와야할지 어려워하는 모습을 보인다
    - Map MCP server 를 Naver, Kakao, Tmap 을 추가해뒀다고 하면, POI 정보를 요청할 시 해당 POI 를 갖지 않은 CP 에 요청이 날아갈 수 있다
    - Prompt 에서 미리 지정해주면 되지만, 유저가 항상 어느 정보가 어디에 있는지 알고 있어야 한다는 문제가 있다

## Reference

- [Introduction - Model Context Protocol](https://modelcontextprotocol.io/introduction)
- [GitHub - modelcontextprotocol/python-sdk: The official Python SDK for Model Context Protocol servers and clients](https://github.com/modelcontextprotocol/python-sdk)
- [MCP의 모든 것을 알아봅시다.](https://velog.io/@k-svelte-master/what-is-mcp)
