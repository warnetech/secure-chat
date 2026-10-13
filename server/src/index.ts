export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    // Health check: confirms the server is running
    if (url.pathname === "/healthz") {
      return Response.json({ status: "ok", service: "secure-chat" });
    }

    return new Response("secure-chat server", { status: 200 });
  },
};
