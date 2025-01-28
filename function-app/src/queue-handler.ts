import { InvocationContext } from "@azure/functions";

export async function queueHandler(queueItem: unknown, context: InvocationContext) {
    const queueMessage = queueItem as any;
    context.info("queue-handler invoked");
    context.info(queueMessage);
}
