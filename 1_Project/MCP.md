---
title: MCP
date: 2025-03-15T20:43:37+09:00
aliases: 
tags:
  - ai
description: 
updated: 2025-04-03T23:50
---

## MCP Server

- [[uv]] 사용
    - ~~Cursor 에서 uv 로 MCP server 를 실행시키기는 어려웠다. [[Docker]] 컨테이너를 빌드하는게 좋을듯~~
    - 아마 uv 의 동작 방식 때문에 그런듯하다. uv 는 venv 에 있는 mcp 를 실행시키는 것으로 아는데 확인이 필요하다.
        - 문제 해결
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

## Reference

- [Introduction - Model Context Protocol](https://modelcontextprotocol.io/introduction)