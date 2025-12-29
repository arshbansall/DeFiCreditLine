import Fastify from "fastify";
import cors from "@fastify/cors";

export function buildApp() {
  const app = Fastify({logger: true});
  
  // add routes
  
  return app;
}