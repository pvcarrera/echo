# Echo server
Echo is an exercise created by my friend @soulim to experiment, learn and find different ways of building REST APIs with Ruby.

The main purpose of Echo is to serve ephemeral/mock endpoints created with parameters specified by clients

In this iteration I'm trying to find the simplest way of building a REST API that it's easy to maintain. In order to accomplish that these are the decisions I made

- Stick to Rack apps, no Rails.
- Follow the  [API design first approach](https://apisyouwonthate.com/blog/api-design-first-vs-code-first):
    - The [OpenAPI](https://www.openapis.org/) will be the only source of true for the API, any change to the REST API will start with an update on the specification.
    - The [commitee](https://github.com/interagent/committee) middlewares will validate that the requests meet the OpenAPI specifications, coerce the request parameters and provide spec helpers to assert that the code fulfill the OpenAPI contract
    - The REST API will follow [JSON:API](https://jsonapi.org/) specification.
    - The API specification development will be done with [Stoplight](https://stoplight.io/). There is no need to edit an OpenAPI specification manually.

## Task definition

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

### Terms

- _Echo_ or _server_: it's what I'm going to implement :)
- _mock endpoint_: the main purpose of Echo is to serve ephemeral/mock endpoints created with parameters specified by clients
- _Endpoints API_: a set of endpoints (`GET|POST|PATCH|DELETE /endpoints{/:id}`) designated to manage mock endpoints served by Echo. See examples in "Technical specifications" section

### Server requirements

- The server MUST implement `GET /endpoints` endpoint. The server MUST return a list of mock endpoints created by you, using `POST /endpoints` endpoint, or an empty array if no mock endpoints are defined yet. See examples in "Technical specifications" section.
- The server MUST implement `POST /endpoints` endpoint. The server creates a mock endpoint according to data from the payload. The server SHOULD validate received data. See examples in "Technical specifications" section.
- The server MUST implement `PATCH /endpoints{/:id}` endpoint. The server updates the existing mock endpoint according to data from the payload. The server SHOULD NOT accept invalid data or update non-existing mock endpoints. If requested mock endpoint doesn't exist, the server MUST respond with `404 Not found`. See examples in "Technical specifications" section.
- The server MUST implement `DELETE /endpoints{/:id}` endpoint. The server deletes the requested mock endpoint. If requested mock endpoint doesn't exist, the server MUST respond with `404 Not found`. See examples in "Technical specifications" section.
- The server MUST serve mock endpoints as they defined by clients. Mock endpoints MUST be available over HTTP. All mock endpoints are available as they defined. Example: if there is a mock endpoint `POST /foo/bar/baz`, it MUST be available only for `POST` requests at `/foo/bar/baz` path. It SHALL NOT be available via `GET /foo/bar/baz` or even `POST /foo/bar` because these are different endpoints. Basically Echo works like "what you define is what you get".
- Validate incoming requests as might contain invalid data.
- The server MAY implement authentication for Endpoints API.

## Technical specification

The server operates on _Endpoint_ entities:

    Endpoint {
      id    String
      verb  String
      path  String

      response {
        code    Integer
        headers Hash<String, String>
        body    String
      }
    }

- `id` (required), a string value that uniquely identifies an Endpoint
- `verb` (required), a string value that may take one of HTTP method names. See [RFC 7231](https://tools.ietf.org/html/rfc7231#section-4.3)
- `path` (required), a string value of the path part of URL
- `response` (required), an object with following attributes:
  - `code` (required), an integer status code returned by Endpoint
  - `headers` (optional), a key-value structure where keys represent HTTP header
    names and values hold actual values of these headers returned by Endpoint
  - `body` (optional), a string representation of response body returned by
    Endpoint

Echo serves mock endpoints as they previously defined by the clients via Endpoints API. For example it will serve `{ "message": "Hello world" }` as response from `GET /foo/bar` endpoint, if this endpoint was defined upfront via Endpoints API.
### Examples

<details>
  <summary>List endpoints</summary>
  <markdown>
#### Request

    GET /endpoints HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": [
            {
                "type": "endpoints",
                "id": "12345",
                "attributes": [
                    "verb": "GET",
                    "path": "/greeting",
                    "response": {
                      "code": 200,
                      "headers": {},
                      "body": "\"{ \"message\": \"Hello, world\" }\""
                    }
                ]
            }
        ]
    }

  </markdown>
</details>

<details>
  <summary>Create endpoint</summary>
  <markdown>
#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 201 Created
    Location: http://example.com/greeting
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

  </markdown>
</details>

<details>
  <summary>Update endpoint</summary>
  <markdown>
#### Request

    PATCH /endpoints/12345 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345"
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }

  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>
#### Request

    DELETE /endpoints/12345 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 204 No Content

  </markdown>
</details>

<details>
  <summary>Error response</summary>
  <markdown>
In case client makes unexpected response or server encountered an internal problem, Echo should provide proper error response.

#### Request

    DELETE /endpoints/1234567890 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested Endpoint with ID `1234567890` does not exist"
            }
        ]
    }

  </markdown>
</details>

<details open>
  <summary>Sample scenario</summary>
  <markdown>
#### 1. Client requests non-existing path

    > GET /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

#### 2. Client creates an endpoint

    > POST /endpoints HTTP/1.1
    > Content-Type: application/vnd.api+json
    > Accept: application/vnd.api+json
    >
    > {
    >     "data": {
    >         "type": "endpoints",
    >         "attributes": {
    >             "verb": "GET",
    >             "path": "/hello",
    >             "response": {
    >                 "code": 200,
    >                 "headers": {
    >                     "Content-Type": "application/json"
    >                 },
    >                 "body": "\"{ \"message\": \"Hello, world\" }\""
    >             }
    >         }
    >     }
    > }

    HTTP/1.1 201 Created
    Location: http://example.com/hello
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### 3. Client requests the recently created endpoint

    > GET /hello HTTP/1.1
    > Accept: application/json

    HTTP/1.1 200 OK
    Content-Type: application/json

    { "message": "Hello, world" }

#### 4. Client requests the endpoint on the same path, but with different HTTP verb

The server responds with HTTP 404 because only `GET /hello` endpoint is defined.

NOTE: if you could imagine different behavior from the server, feel free to propose it in your solution.

    > POST /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

  </markdown>
</details>
