import { InvocationContext } from "@azure/functions";

export async function queueHandler(queueItem: unknown, context: InvocationContext) {
    const receivingTimestamp = new Date();

    const queueMessage = queueItem as { message: string, timestamp: string };
    context.info("queue-handler invoked");
    context.info(queueMessage);

    const sendTimestamp = new Date(queueMessage.timestamp);
    const duration = receivingTimestamp.getTime() - sendTimestamp.getTime();

    context.info(`Waited ${duration / 1000} seconds for message to be consumed`);
}
