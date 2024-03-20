import { Context, HttpRequest, AzureFunction } from "@azure/functions";

import { McmaApiRouteCollection } from "@mcma/api";
import { AppInsightsLoggerProvider } from "@mcma/azure-logger";
import { AzureFunctionApiController } from "@mcma/azure-functions-api";

const loggerProvider = new AppInsightsLoggerProvider("api-handler1");

const routes = new McmaApiRouteCollection()
    .addRoute("GET", "/test", async (requestContext) => {
        requestContext.setResponseBody("OK");
    });

const restController =
    new AzureFunctionApiController(
        {
            routes,
            loggerProvider,
        });

export const handler: AzureFunction = async (context: Context, request: HttpRequest) => {
    const logger = await loggerProvider.get(context.invocationId);
    try {
        logger.functionStart(context.invocationId);
        logger.debug(context);
        logger.debug(request);

        return await restController.handleRequest(request);
    } catch (error) {
        logger.error(error);
        throw error;
    } finally {
        logger.functionEnd(context.invocationId);
        loggerProvider.flush();
    }
};
