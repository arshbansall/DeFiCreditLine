import type { FastifyRequest, FastifyReply } from "fastify";

export function requireIdempotency(req: FastifyRequest, reply: FastifyReply, done: (err?: Error) => void) {
  const key = req.headers["idempotency-key"];
  const idem = Array.isArray(key) ? key[0] : key ? String(key) : null;

  if (!idem) {
    reply.code(400).send({
      error: "missing_idempotency_key",
      hint: "Send Idempotency-Key header",
    });
    return;
  }

  // attach for later use
  (req as any).idempotencyKey = idem;
  done();
}
