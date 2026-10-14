interface Env {
  DB: D1Database;
}

function respond(
  body: BodyInit | null,
  status = 200,
  contentType = "text/plain; charset=utf-8"
): Response {
  return new Response(body, {
    status,
    headers: {
      "Content-Type": contentType,
      "X-Content-Type-Options": "nosniff",
      "Cache-Control": "no-store",
    },
  });
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // Preserve the existing health-check response.
    if (url.pathname === "/healthz") {
      return respond(
        JSON.stringify({ status: "ok", service: "secure-chat" }),
        200,
        "application/json; charset=utf-8"
      );
    }

    if (url.pathname === "/api/db-check" && request.method === "GET") {
      try {
        await env.DB.prepare("SELECT 1 AS ok").first();
        return respond(
          JSON.stringify({ status: "ok", db: true }),
          200,
          "application/json; charset=utf-8"
        );
      } catch {
        return respond(
          JSON.stringify({ status: "error", db: false }),
          500,
          "application/json; charset=utf-8"
        );
      }
    }

    return respond("Not found", 404);
  },
};
