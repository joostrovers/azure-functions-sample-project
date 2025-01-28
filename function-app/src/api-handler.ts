import { HttpRequest, HttpResponse, HttpResponseInit, InvocationContext } from "@azure/functions";
import { DefaultAzureCredential } from "@azure/identity";
import { QueueClient } from "@azure/storage-queue";


export async function apiHandler(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit | HttpResponse> {
    const msg = `api-handler invoked at ${new Date().toISOString()}`;

    context.info(msg);

    try {
        const queueClient = new QueueClient(process.env.QUEUE_URL, new DefaultAzureCredential());
        await queueClient.sendMessage(toBase64(msg));

        return {
            status: 200,
            body: msg,
        }
    } catch (error) {
        return {
            status: 200,
            body: error.toString(),
        }
    }
}

function toBase64(text: string): string {
    // check for browser function for base64
    if (typeof btoa !== "undefined") {
        return btoa(text);
    }

    // check for Node.js Buffer class for converting
    if (typeof Buffer !== "undefined" && typeof Buffer.from !== "undefined") {
        return Buffer.from(text).toString("base64");
    }

    // not sure what platform we're on - throw an error to indicate this is not supported
    throw new Error("Unable to convert from plain text to base64 string. Neither the function 'btoa' nor the class 'Buffer' are defined on this platform.");
}
