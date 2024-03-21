import { AzureFunction, Context } from "@azure/functions";

import { AppInsightsLoggerProvider } from "@mcma/azure-logger";

const loggerProvider = new AppInsightsLoggerProvider("queue-consumer2");

export const handler: AzureFunction = async (context: Context) => {
    const queueMessage = context.bindings.queueMessage;
    const logger = await loggerProvider.get(context.invocationId, queueMessage.tracker);

    try {
        logger.functionStart(context.invocationId);
        logger.debug(context);
        logger.debug(queueMessage);
    } catch (error) {
        logger.error(error.message);
        logger.error(error);
    } finally {
        logger.functionEnd(context.invocationId);
        loggerProvider.flush();
    }
};
