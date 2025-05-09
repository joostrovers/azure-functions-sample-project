import { app } from "@azure/functions";

import { apiHandler } from "./api-handler";
import { queueHandler } from "./queue-handler";

app.http("api-handler", {
    route: "{*path}",
    methods: ["GET"],
    authLevel: "anonymous",
    handler: apiHandler
});

app.storageQueue("queue-handler", {
    queueName: process.env.QUEUE_NAME,
    connection: undefined,
    handler: queueHandler,
});
