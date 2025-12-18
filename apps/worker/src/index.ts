import "dotenv/config";
import { Worker } from "bullmq";
import { Redis } from "ioredis";

const connection = new Redis(process.env.REDIS_URL || "redis://localhost:6379", {
  maxRetriesPerRequest: null,
});

new Worker(
  "credit-jobs",
  async (job) => {
    console.log("processing job:", job.name, job.data);
    // TODO: deliver webhook / recompute credit state / etc.
    return { ok: true };
  },
  { connection }
);

console.log("Worker running...");