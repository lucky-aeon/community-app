---
title: 社区
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.23"

---

# 社区

Base URLs:

# Authentication

# 前台/评论

## POST 发布/回复评论

POST /community/comments/comment

发布评论不需要传入parentId，rootId
回复评论需要传入

> Body 请求参数

```json
{
  "content": "et fugiat",
  "articleId": 2
}
```

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|Authorization|header|string| 否 ||none|
|body|body|object| 否 ||none|
|» parentId|body|integer| 否 | 父评论id|发布评论不需要传|
|» rootId|body|integer| 否 | 根评论id|发布评论不需要传|
|» content|body|string| 是 | 内容|none|
|» articleId|body|integer| 是 | 文章id|none|
|» toUserId|body|integer| 否 | 回复人id|根评论则没有|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET 查看文章的评论(前台展示)

GET /community/comments/byArticleId/{articleId}

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|articleId|path|integer| 是 ||文章id|
|Authorization|header|string| 否 ||none|

> 返回示例

> 200 Response

```json
{
  "code": 0,
  "data": {
    "data": [
      {
        "id": 0,
        "createdAt": "string",
        "updatedAt": "string",
        "DeletedAt": "string",
        "parentId": 0,
        "rootId": 0,
        "content": "string",
        "FromUserId": 0,
        "toUserId": 0,
        "articleId": 0,
        "tenantId": 0,
        "childComments": [
          {
            "id": null,
            "createdAt": null,
            "updatedAt": null,
            "DeletedAt": null,
            "parentId": null,
            "rootId": null,
            "content": null,
            "FromUserId": null,
            "toUserId": null,
            "articleId": null,
            "tenantId": null,
            "childComments": null,
            "childCommentNumber": null,
            "fromUserName": null,
            "toUserName": null,
            "articleTitle": null
          }
        ],
        "childCommentNumber": 0,
        "fromUserName": "string",
        "toUserName": "string",
        "articleTitle": "string"
      }
    ],
    "count": 0
  },
  "msg": "string",
  "ok": true
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» code|integer|true|none||none|
|» data|object|true|none||none|
|»» data|[object]|true|none||none|
|»»» id|integer|true|none||none|
|»»» createdAt|string|true|none||none|
|»»» updatedAt|string|true|none||none|
|»»» DeletedAt|string¦null|true|none||none|
|»»» parentId|integer|true|none|父评论id|none|
|»»» rootId|integer|true|none|根评论id|none|
|»»» content|string|true|none|内容|none|
|»»» FromUserId|integer|true|none|发布人id|none|
|»»» toUserId|integer|true|none|回复人id|为空说明一级评论|
|»»» articleId|integer|true|none|文章id|none|
|»»» tenantId|integer|true|none||none|
|»»» childComments|[object]¦null|true|none|字评论|none|
|»»»» id|integer|true|none||none|
|»»»» createdAt|string|true|none||none|
|»»»» updatedAt|string|true|none||none|
|»»»» DeletedAt|null|true|none||none|
|»»»» parentId|integer|true|none||none|
|»»»» rootId|integer|true|none||none|
|»»»» content|string|true|none||none|
|»»»» FromUserId|integer|true|none||none|
|»»»» toUserId|integer|true|none||none|
|»»»» articleId|integer|true|none||none|
|»»»» tenantId|integer|true|none||none|
|»»»» childComments|null|true|none||none|
|»»»» childCommentNumber|integer|true|none||none|
|»»»» fromUserName|string|true|none||none|
|»»»» toUserName|string|true|none||none|
|»»»» articleTitle|string|true|none||none|
|»»» childCommentNumber|integer|true|none|自评论数量|none|
|»»» fromUserName|string|true|none|发布人昵称|none|
|»»» toUserName|string|true|none|回复人昵称|none|
|»»» articleTitle|string|true|none|文章title|none|
|»» count|integer|true|none|评论总数|分页|
|» msg|string|true|none||none|
|» ok|boolean|true|none||none|

## GET 查询根评论下的评论

GET /community/comments/byRootId/{rootId}

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|rootId|path|integer| 是 ||none|
|page|query|integer| 否 ||none|
|limit|query|integer| 否 ||none|
|Authorization|header|string| 否 ||none|

> 返回示例

```json
{
  "Code": 200,
  "Data": {
    "count": 5,
    "data": [
      {
        "id": 16,
        "CreatedAt": "2024-01-29T11:51:55+08:00",
        "UpdatedAt": "2024-01-29T11:51:55+08:00",
        "DeletedAt": null,
        "parentId": 0,
        "rootId": 16,
        "content": "enim aliquip laborum culpa",
        "UserId": 0,
        "articleId": 2,
        "TenantId": 0,
        "ChildComments": [
          {
            "id": 17,
            "CreatedAt": "2024-01-29T11:53:30+08:00",
            "UpdatedAt": "2024-01-29T11:53:30+08:00",
            "DeletedAt": null,
            "parentId": 16,
            "rootId": 16,
            "content": "enim aliquip laborum culpa",
            "UserId": 0,
            "articleId": 2,
            "TenantId": 0,
            "ChildComments": null,
            "ChildCommentNumber": 0
          },
          {
            "id": 18,
            "CreatedAt": "2024-01-29T11:53:52+08:00",
            "UpdatedAt": "2024-01-29T11:53:52+08:00",
            "DeletedAt": null,
            "parentId": 16,
            "rootId": 16,
            "content": "enim aliquip laborum culpa111",
            "UserId": 0,
            "articleId": 2,
            "TenantId": 0,
            "ChildComments": null,
            "ChildCommentNumber": 0
          },
          {
            "id": 20,
            "CreatedAt": "2024-01-29T20:01:06+08:00",
            "UpdatedAt": "2024-01-29T20:01:06+08:00",
            "DeletedAt": null,
            "parentId": 18,
            "rootId": 16,
            "content": "incididunt",
            "UserId": 0,
            "articleId": 2,
            "TenantId": 0,
            "ChildComments": null,
            "ChildCommentNumber": 0
          },
          {
            "id": 22,
            "CreatedAt": "2024-01-29T20:01:12+08:00",
            "UpdatedAt": "2024-01-29T20:01:12+08:00",
            "DeletedAt": null,
            "parentId": 20,
            "rootId": 16,
            "content": "incididunt",
            "UserId": 0,
            "articleId": 2,
            "TenantId": 0,
            "ChildComments": null,
            "ChildCommentNumber": 0
          }
        ],
        "ChildCommentNumber": 0
      }
    ]
  },
  "Msg": ""
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» Code|integer|true|none||none|
|» Data|object|true|none||none|
|»» count|integer|true|none||none|
|»» data|[object]|true|none||none|
|»»» id|integer|false|none||none|
|»»» CreatedAt|string|false|none||none|
|»»» UpdatedAt|string|false|none||none|
|»»» DeletedAt|null|false|none||none|
|»»» parentId|integer|false|none||none|
|»»» rootId|integer|false|none||none|
|»»» content|string|false|none||none|
|»»» UserId|integer|false|none||none|
|»»» articleId|integer|false|none||none|
|»»» TenantId|integer|false|none||none|
|»»» ChildComments|[object]|false|none||none|
|»»»» id|integer|true|none||none|
|»»»» CreatedAt|string|true|none||none|
|»»»» UpdatedAt|string|true|none||none|
|»»»» DeletedAt|null|true|none||none|
|»»»» parentId|integer|true|none||none|
|»»»» rootId|integer|true|none||none|
|»»»» content|string|true|none||none|
|»»»» UserId|integer|true|none||none|
|»»»» articleId|integer|true|none||none|
|»»»» TenantId|integer|true|none||none|
|»»»» ChildComments|null|true|none||none|
|»»»» ChildCommentNumber|integer|true|none||none|
|»»» ChildCommentNumber|integer|false|none||none|
|» Msg|string|true|none||none|

## DELETE 删除评论

DELETE /community/comments/{id}

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|id|path|integer| 是 ||评论id|
|Authorization|header|string| 否 ||none|

> 返回示例

> 200 Response

```json
{}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

## GET 查询文章下的所有评论(用户管理端)

GET /community/comments/allCommentsByArticleId/{articleId}

该接口用于用户的后台管理端使用

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|articleId|path|string| 是 ||none|
|Authorization|header|string| 否 ||none|

> 返回示例

```json
{
  "Code": 200,
  "Data": {
    "count": 6,
    "data": [
      {
        "id": 10,
        "CreatedAt": "0001-01-01T00:00:00Z",
        "UpdatedAt": "0001-01-01T00:00:00Z",
        "DeletedAt": null,
        "parentId": 0,
        "rootId": 0,
        "content": "",
        "UserId": 0,
        "articleId": 0,
        "TenantId": 0,
        "ChildComments": null,
        "ChildCommentNumber": 0
      },
      {
        "id": 11,
        "CreatedAt": "0001-01-01T00:00:00Z",
        "UpdatedAt": "0001-01-01T00:00:00Z",
        "DeletedAt": null,
        "parentId": 0,
        "rootId": 0,
        "content": "",
        "UserId": 0,
        "articleId": 0,
        "TenantId": 0,
        "ChildComments": null,
        "ChildCommentNumber": 0
      }
    ]
  },
  "Msg": ""
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» Code|integer|true|none||none|
|» Data|object|true|none||none|
|»» count|integer|true|none||none|
|»» data|[object]|true|none||none|
|»»» id|integer|true|none||none|
|»»» CreatedAt|string|true|none||none|
|»»» UpdatedAt|string|true|none||none|
|»»» DeletedAt|null|true|none||none|
|»»» parentId|integer|true|none||none|
|»»» rootId|integer|true|none||none|
|»»» content|string|true|none||none|
|»»» UserId|integer|true|none||none|
|»»» articleId|integer|true|none||none|
|»»» TenantId|integer|true|none||none|
|»»» ChildComments|null|true|none||none|
|»»» ChildCommentNumber|integer|true|none||none|
|» Msg|string|true|none||none|

## POST 采纳评论

POST /community/comments/adoption

> Body 请求参数

```json
{
  "articleId": 74,
  "CommentId": 220
}
```

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|Authorization|header|string| 否 ||none|
|body|body|object| 否 ||none|
|» articleId|body|integer| 是 ||none|
|» CommentId|body|integer| 是 ||none|

> 返回示例

```json
{
  "code": 2000,
  "data": null,
  "msg": "取消采纳",
  "ok": true
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» code|integer|true|none||none|
|» data|null|true|none||none|
|» msg|string|true|none||none|
|» ok|boolean|true|none||none|

## GET 获取采纳评论

GET /community/comments/adaptions

### 请求参数

|名称|位置|类型|必选|中文名|说明|
|---|---|---|---|---|---|
|articleId|query|string| 否 ||文章id|
|page|query|string| 否 ||none|
|limit|query|string| 否 ||none|
|Authorization|header|string| 否 ||none|

> 返回示例

```json
{
  "code": 200,
  "data": {
    "list": [
      {
        "id": 234,
        "createdAt": "2024-03-30 19:20:25",
        "updatedAt": "2024-03-30 19:20:25",
        "DeletedAt": null,
        "parentId": 0,
        "rootId": 234,
        "content": "解决2",
        "FromUserId": 1,
        "toUserId": 0,
        "articleId": 91,
        "tenantId": 0,
        "childComments": null,
        "childCommentNumber": 0,
        "fromUserName": "xhy",
        "toUserName": "",
        "articleTitle": "java",
        "fromUserAvatar": "1/1711724161657",
        "adoptionState": true
      }
    ],
    "total": 3
  },
  "msg": "成功",
  "ok": true
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### 返回数据结构

状态码 **200**

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|» code|integer|true|none||none|
|» data|object|true|none||none|
|»» list|[object]|true|none||none|
|»»» id|integer|false|none||none|
|»»» createdAt|string|false|none||none|
|»»» updatedAt|string|false|none||none|
|»»» DeletedAt|null|false|none||none|
|»»» parentId|integer|false|none||none|
|»»» rootId|integer|false|none||none|
|»»» content|string|false|none||none|
|»»» FromUserId|integer|false|none||none|
|»»» toUserId|integer|false|none||none|
|»»» articleId|integer|false|none||none|
|»»» tenantId|integer|false|none||none|
|»»» childComments|null|false|none||none|
|»»» childCommentNumber|integer|false|none||none|
|»»» fromUserName|string|false|none||none|
|»»» toUserName|string|false|none||none|
|»»» articleTitle|string|false|none||none|
|»»» fromUserAvatar|string|false|none||none|
|»»» adoptionState|boolean|false|none||none|
|»» total|integer|true|none||none|
|» msg|string|true|none||none|
|» ok|boolean|true|none||none|

# 数据模型

